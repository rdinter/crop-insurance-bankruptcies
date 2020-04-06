# Download all of the planted acreage information
# NASS API for their Quickstats web interface:
# https://quickstats.nass.usda.gov/

# ---- start --------------------------------------------------------------

# devtools::install_github("rdinter/usdarnass")
library("usdarnass")
library("tidyverse")
# source("0-data/0-api_keys.R")
sumn <- function(x) ifelse(all(is.na(x)), NA, sum(x, na.rm = T))

# Create a directory for the data
local_dir    <- "0-data/NASS"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir, recursive = T)
if (!file.exists(data_source)) dir.create(data_source, recursive = T)


dry_edible <- paste0("DRY EDIBLE, ", c("BLACK", "GREAT NORTHERN",
                                       "INCL CHICKPEAS", "LIMA",
                                       "NAVY", "OTHER", "PINK", "PINTO",
                                       "RED, KIDNEY", "SMALL, RED",
                                       "SMALL, WHITE"))

keep_class <- c("ALL CLASSES", "DRY EDIBLE", dry_edible,
                "GREEN", "AUSTRIAN WINTER",
                "NON-OIL TYPE", "OIL TYPE", "PIMA", "SNAP", "SPRING, DURUM",
                "SPRING, (EXCL DURUM)", "UPLAND", "WINTER")

# ---- planted ------------------------------------------------------------

# County Level Area Planted commodities we have available and their years
com_county <- nass_param(param = "commodity_desc", agg_level_desc = "COUNTY",
                         statisticcat_desc = "AREA PLANTED")
com_year <- map(com_county, function(x) {
  nass_param(param = "year", agg_level_desc = "COUNTY",
             statisticcat_desc = "AREA PLANTED", commodity_desc = x)
})

# Only run this once, it is time intensive. Save the file then do manipulations
#  from the saved raw data.

area_planted <- map(1980:(as.numeric(format(Sys.Date(), "%Y")) - 1),
                    function(x) {
  print(x)
  nass_data(year = x, agg_level_desc = "COUNTY",
            statisticcat_desc = "AREA PLANTED", numeric_vals = T)
})

j5 <- bind_rows(area_planted)

write_rds(j5, "0-data/NASS/area_planted_temp.rds")

j5 <- read_rds("0-data/NASS/area_planted_temp.rds")

plants <- j5 %>% 
  filter(prodn_practice_desc %in% c("ALL PRODUCTION PRACTICES", "IN THE OPEN"),
         class_desc %in% keep_class,
         !(short_desc %in% c("SUNFLOWER - ACRES PLANTED",
                             "WHEAT - ACRES PLANTED"))) %>% 
  mutate(fips = parse_number(paste0(state_fips_code, county_code)),
         new_com = case_when(class_desc == "DRY EDIBLE" &
                               commodity_desc == "PEAS" ~ "DRY PEAS",
                             class_desc == "GREEN" ~ "GREEN PEAS",
                             T ~ commodity_desc))

plants_county <- plants %>% 
  group_by(year, fips, state_fips_code, county_code,
           asd_code, asd_desc, commodity_desc) %>% 
  summarise(val = sumn(Value)) %>% 
  spread(commodity_desc, val)

# plants_county %>%
#   arrange(year, state_fips_code, asd_code, county_code) %>% 
#   View

# Correct for missing values in the "other"
plants_impute <- plants_county %>% 
  group_by(state_fips_code) %>% 
  complete(year, nesting(state_fips_code, county_code, asd_code, asd_desc)) %>% 
  ungroup() %>% 
  group_by(year, state_fips_code, asd_code) %>% 
  mutate_at(vars(BARLEY:WHEAT),
            list(~ifelse(is.na(.),
                         .[county_code == "998"] / sum(is.na(.)), .))) %>% 
  filter(county_code != "998") %>% 
  rename_at(vars(BARLEY:WHEAT), list(~paste0(., "_impute")))

planted <- plants_impute %>% 
  left_join(plants_county) %>% 
  rename_all(list(~str_replace_all(., " ", ""))) %>% 
  ungroup()

# There appears to be issues with fips being in multiple ASD in the early 80s!!
#  a potential solution? Remove the ASD classes?
plant <- planted %>%
  select(year, fips, BARLEY_impute:WHEAT) %>%
  filter(!is.na(fips)) %>% 
  group_by(year, fips) %>%
  summarise_all(sumn)

# Add in the county information?

write_csv(plant, paste0(local_dir, "/planted.csv"))
write_rds(plant, paste0(local_dir, "/planted.rds"))

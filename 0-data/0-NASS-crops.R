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

# Issue: should we break apart the Peas into separate categories instead of
#  being combined?

# Commodity and start year:
# "BARLEY" 1924 "BEANS" 1944 "CANOLA" 1999 "CORN" 1924 "COTTON" 1928
# "FLAXSEED" 1924 "LENTILS" 1999 "MUSTARD" 1999 "OATS" 1924 "PEANUTS" 1965
# "PEAS" 1972 "PEPPERS" 2017 "POTATOES" 1929 "RICE" 1953 "RYE" 1931
# "SAFFLOWER" 1999 "SORGHUM" 1940 "SOYBEANS" 1938 "SUGARBEETS" 1939
# "SUNFLOWER" 1971 "SWEET CORN" 1977 "SWEET POTATOES" 1925 "TOMATOES" 1973
# "WHEAT" 1919

# BARLEY, BEANS, CORN, COTTON FLAXSEED, OATS, PEANUTS, PEAS, POTATOES, RICE,
#  RYE, SORGHUM, SOYBEAMS, SUGARBEETS, SUNFLOWER, SWEET CORN, SWEET POTATOES,
#  TOMATOES, WHEAT

# The crossover that makes sense (above 1990): CORN (and HYBRID CORN SEED),
#  WHEAT, SOYBEANS, OATS, GRAIN SORGHUM and SILAGE SORGHUM (as SORGHUM),
#  BARLEY, COTTON,
#  SUNFLOWERS (as SUNFLOWER), DRY BEANS (as BEANS), PEANUTS, POTATOES,
#  SUGAR BEETS (as SUGARBEETS), RICE, FLAX (as FLAXSEED),
#  GREEN PEAS AND DRY PEAS (as PEAS), SWEET CORN and FRESH MARKET SWEET CORN,
#  RYE, TOMATOES and FRESH MARKET TOMATOES, 

dry_edible <- paste0("DRY EDIBLE, ", c("BLACK", "GREAT NORTHERN",
                                       "INCL CHICKPEAS", "LIMA",
                                       "NAVY", "OTHER", "PINK", "PINTO",
                                       "RED, KIDNEY", "SMALL, RED",
                                       "SMALL, WHITE"))

keep_class <- c("ALL CLASSES", "DRY EDIBLE", dry_edible,
                "GREEN", "AUSTRIAN WINTER",
                "NON-OIL TYPE", "OIL TYPE", "PIMA", "SNAP", "SPRING, DURUM",
                "SPRING, (EXCL DURUM)", "UPLAND", "WINTER")

# WHEAT - ACRES PLANTED: lasts from 1989 until 2008 then stops. Need to manually
#  add the spring and winter wheats together.
# Same with SUNFLOWER - ACRES PLANTED: for non-oil type and oil type
# RYE stops in 2009
# Keep BEANS, DRY EDILE - ACRES PLANTED and BEANS, SNAP, PROCESSING - ACRES PLANTED

# Easiest to keep the class_desc of the important ones then remove the wheat and
#  sunflower totals

# ---- ag-district-planted ------------------------------------------------

# Ag District level
com_agd <- nass_param(param = "commodity_desc",
                      agg_level_desc = "AGRICULTURAL DISTRICT",
                      statisticcat_desc = "AREA PLANTED")
agd_year <- map(com_agd, function(x) {
  nass_param(param = "year", agg_level_desc = "AGRICULTURAL DISTRICT",
             statisticcat_desc = "AREA PLANTED", commodity_desc = x)
})

area_planted <- map(1980:format(Sys.Date(), "%Y"), function(x) {
  print(x)
  tryCatch(nass_data(year = x, agg_level_desc = "AGRICULTURAL DISTRICT",
                     statisticcat_desc = "AREA PLANTED", numeric_vals = T),
           error = function(e) return(data.frame(year = x)))
})

j5 <- bind_rows(area_planted)

write_rds(j5, "0-data/NASS/area_planted_agd_temp.rds")


plants <- j5 %>% 
  filter(prodn_practice_desc %in% c("ALL PRODUCTION PRACTICES", "IN THE OPEN"),
         class_desc %in% keep_class,
         !(short_desc %in% c("SUNFLOWER - ACRES PLANTED",
                             "WHEAT - ACRES PLANTED")))

plants_asd <- plants %>% 
  group_by(year, state_fips_code, asd_code, asd_desc, commodity_desc) %>% 
  summarise(val = sumn(Value)) %>% 
  spread(commodity_desc, val) %>% 
  ungroup()

write_csv(plants_asd, paste0(local_dir, "/plants_asd.csv"))
write_rds(plants_asd, paste0(local_dir, "/plants_asd.rds"))

# Crosswalk for the ASD and FIPS codes

agd_cross <- nass_data(year = "2012", agg_level_desc = "COUNTY",
                       short_desc = paste0("AG LAND, INCL BUILDINGS -",
                                           " ASSET VALUE, MEASURED IN $"))
agd_cross <- agd_cross %>% 
  select(location_desc, county_name, county_code, state_fips_code,
         asd_desc, asd_code) %>% 
  mutate(fips = parse_number(paste0(state_fips_code, county_code)))

write_csv(agd_cross, paste0(local_dir, "/agd_cross.csv"))
write_rds(agd_cross, paste0(local_dir, "/agd_cross.rds"))
# 
# # ---- planted ------------------------------------------------------------
# 
# # County Level Area Planted commodities we have available and their years
# com_county <- nass_param(param = "commodity_desc", agg_level_desc = "COUNTY",
#                          statisticcat_desc = "AREA PLANTED")
# com_year <- map(com_county, function(x) {
#   nass_param(param = "year", agg_level_desc = "COUNTY",
#              statisticcat_desc = "AREA PLANTED", commodity_desc = x)
# })
# 
# # Only run this once, it is time intensive. Save the file then do manipulations
# #  from the saved raw data.
# 
# # area_planted <- map(1980:(as.numeric(format(Sys.Date(), "%Y")) - 1),
# #                     function(x) {
# #   print(x)
# #   nass_data(year = x, agg_level_desc = "COUNTY",
# #             statisticcat_desc = "AREA PLANTED", numeric_vals = T)
# # })
# 
# j5 <- bind_rows(area_planted)
# 
# write_rds(j5, "0-data/NASS/area_planted_temp.rds")
# 
# j5 <- read_rds("0-data/NASS/area_planted_temp.rds")
# 
# plants <- j5 %>% 
#   filter(prodn_practice_desc %in% c("ALL PRODUCTION PRACTICES", "IN THE OPEN"),
#          class_desc %in% keep_class,
#          !(short_desc %in% c("SUNFLOWER - ACRES PLANTED",
#                              "WHEAT - ACRES PLANTED"))) %>% 
#   mutate(fips = parse_number(paste0(state_fips_code, county_code)),
#          new_com = case_when(class_desc == "DRY EDIBLE" &
#                                commodity_desc == "PEAS" ~ "DRY PEAS",
#                              class_desc == "GREEN" ~ "GREEN PEAS",
#                              T ~ commodity_desc))
# 
# plants_county <- plants %>% 
#   group_by(year, fips, state_fips_code, county_code,
#            asd_code, asd_desc, commodity_desc) %>% 
#   summarise(val = sumn(Value)) %>% 
#   spread(commodity_desc, val)
# 
# # plants_county %>%
# #   arrange(year, state_fips_code, asd_code, county_code) %>% 
# #   View
# 
# # Correct for missing values in the "other"
# plants_impute <- plants_county %>% 
#   group_by(state_fips_code) %>% 
#   complete(year, nesting(state_fips_code, county_code, asd_code, asd_desc)) %>% 
#   ungroup() %>% 
#   group_by(year, state_fips_code, asd_code) %>% 
#   mutate_at(vars(BARLEY:WHEAT),
#             list(~ifelse(is.na(.),
#                         .[county_code == "998"] / sum(is.na(.)), .))) %>% 
#   filter(county_code != "998") %>% 
#   rename_at(vars(BARLEY:WHEAT), list(~paste0(., "_impute")))
# 
# planted <- plants_impute %>% 
#   left_join(plants_county) %>% 
#   rename_all(list(~str_replace_all(., " ", ""))) %>% 
#   ungroup()
# 
# # There appears to be issues with fips being in multiple ASD in the early 80s!!
# #  a potential solution? Remove the ASD classes?
# plant <- planted %>%
#   select(year, fips, BARLEY_impute:WHEAT) %>%
#   filter(!is.na(fips)) %>% 
#   group_by(year, fips) %>%
#   summarise_all(sumn)
# 
# # Add in the county information?
# 
# write_csv(plant, paste0(local_dir, "/planted.csv"))
# write_rds(plant, paste0(local_dir, "/planted.rds"))
# 
# 
# # ---- crops --------------------------------------------------------------
# 
# nass_param(param = "short_desc",
#            commodity_desc = "MILK", agg_level_desc = "COUNTY")
# 
# livestock_desc <- c("CATTLE, INCL CALVES - SALES, MEASURED IN $",
#                     "CHICKENS, BROILERS - PRODUCTION, MEASURED IN HEAD",
#                     "CHICKENS, BROILERS - SALES, MEASURED IN HEAD",
#                     "HOGS - SALES, MEASURED IN $",
#                     "MILK, INCL OTHER DAIRY PRODUCTS - SALES, MEASURED IN $",
#                     "MILK - PRODUCTION, MEASURED IN $",
#                     "MILK - SALES, MEASURED IN $")
# 
# # ---- corn ---------------------------------------------------------------
# 
# corn_short_desc <- c("CORN - ACRES PLANTED",
#                      "CORN - SALES, MEASURED IN $",
#                      "CORN, GRAIN - YIELD, MEASURED IN BU / ACRE")
# 
# cotton_short_desc <- c("COTTON, UPLAND - ACRES PLANTED",
#                        "COTTON, UPLAND - YIELD, MEASURED IN LB / ACRE")
# 
# soy_short_desc <- c("SOYBEANS - ACRES PLANTED",
#                     "SOYBEANS - SALES, MEASURED IN $",
#                     "SOYBEANS - YIELD, MEASURED IN BU / ACRE")
# 
# wheat_short_desc <- c("WHEAT - ACRES PLANTED",
#                       "WHEAT - SALES, MEASURED IN $",
#                       "WHEAT - YIELD, MEASURED IN BU / ACRE")
# 

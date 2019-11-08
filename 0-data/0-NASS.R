# Downloading economic statistics for counties, needs to be ran prior to
#  0-NASS-historical.R

# NASS API for their Quickstats web interface:
# https://quickstats.nass.usda.gov/


# ---- start --------------------------------------------------------------

# devtools::install_github("rdinter/usdarnass")
library("usdarnass")
library("tidyverse")
# devtools::install_github("jcizel/FredR")
library("FredR")
library("lubridate")
source("0-data/0-api-keys.R") # keep your FredR API Key in here

# Create a directory for the data
local_dir    <- "0-data/NASS"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir, recursive = T)
if (!file.exists(data_source)) dir.create(data_source, recursive = T)

# ---- national data ------------------------------------------------------

nass_land  <- nass_data(commodity_desc = "AG LAND",
                        agg_level_desc = "NATIONAL",
                        statisticcat_desc = "ASSET VALUE",
                        freq_desc = "ANNUAL",
                        numeric_vals = T)

national_land <- nass_land %>% 
  bind_rows() %>% 
  mutate(year = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("cropland", "junk", "agland",
                                        "pastureland"))) %>% 
  select(year, val = Value, short_desc) %>% 
  filter(short_desc != "junk") %>% 
  spread(short_desc, val)

nass_farms <-  nass_data(commodity_desc = "FARM OPERATIONS",
                         agg_level_desc = "NATIONAL",
                         short_desc = "FARM OPERATIONS - NUMBER OF OPERATIONS",
                         source_desc = "SURVEY", domain_desc = "TOTAL",
                         numeric_vals = T)

national_land <- nass_farms %>% 
  bind_rows() %>% 
  mutate(year = as.numeric(year)) %>% 
  select(year, farms = Value) %>% 
  distinct() %>% 
  right_join(national_land)

nass_acres <- nass_data(commodity_desc = "FARM OPERATIONS",
                        agg_level_desc = "NATIONAL",
                        short_desc = "FARM OPERATIONS - ACRES OPERATED",
                        source_desc = "SURVEY", domain_desc = "TOTAL",
                        numeric_vals = T)

national_land <- nass_acres %>% 
  bind_rows() %>% 
  mutate(year = as.numeric(year)) %>% 
  select(year, acres = Value) %>% 
  distinct() %>% 
  right_join(national_land)

write.csv(national_land, paste0(local_dir, "/national_agland.csv"),
          row.names = F)

# ---- county data --------------------------------------------------------

years <- as.character(c(1997, 2002, 2007, 2012, 2017))
nass_county <- map(years, function(x){
  nass_data(commodity_desc = "AG LAND",  source_desc = "CENSUS",
            agg_level_desc = "COUNTY",
            statisticcat_desc = "ASSET VALUE",
            year = x, numeric_vals = T)
})

farm_county <- nass_county %>% 
  bind_rows() %>% 
  mutate(FIPS = paste0(state_fips_code, county_code),
         YEAR = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("agland", "agland_per_acre",
                                        "agland_per_farm", "junk"))) %>% 
  select(FIPS, Value, short_desc, YEAR) %>% 
  filter(short_desc != "junk") %>% 
  spread(short_desc, Value) %>% 
  complete(FIPS, YEAR)

# Acreage
acre_items <- nass_param("short_desc", commodity_desc = "AG LAND",
                         source_desc = "CENSUS", agg_level_desc = "COUNTY",
                         statisticcat_desc = "AREA")
acre_items <- c("AG LAND - ACRES" = "acres", 
                "AG LAND, CROP INSURANCE - ACRES" = "acres_insured",
                "AG LAND, OWNED, IN FARMS - ACRES" = "acres_owned",
                "AG LAND, RENTED FROM OTHERS, IN FARMS - ACRES" = "acres_rented",
                "AG LAND, IRRIGATED - ACRES" = "acres_irrigated")

nass_county <- map(names(acre_items), function(x){
  if (x == "AG LAND, IRRIGATED - ACRES") {
    nass_data(commodity_desc = "AG LAND",  source_desc = "CENSUS",
              agg_level_desc = "COUNTY", domain_desc = "TOTAL",
              statisticcat_desc = "AREA",
              short_desc = x,
              numeric_vals = T)
  } else {
    nass_data(commodity_desc = "AG LAND",  source_desc = "CENSUS",
              agg_level_desc = "COUNTY",
              statisticcat_desc = "AREA",
              short_desc = x,
              numeric_vals = T)
  }
})

farm_county <- nass_county %>%
  bind_rows() %>%
  mutate(FIPS = paste0(state_fips_code, county_code),
         YEAR = as.numeric(year),
         short_desc = ifelse(is.na(acre_items[short_desc]), short_desc,
                             acre_items[short_desc])) %>%
  select(FIPS, Value, short_desc, YEAR) %>%
  spread(short_desc, Value) %>% 
  left_join(farm_county)


# Operations
nass_county <- map(years, function(x){
  nass_data(commodity_desc = "FARM OPERATIONS", source_desc = "CENSUS",
            agg_level_desc = "COUNTY",
            short_desc = "FARM OPERATIONS - NUMBER OF OPERATIONS",
            domain_desc = "TOTAL", year = x, numeric_vals = T)
})

farm_county <- nass_county %>% 
  bind_rows() %>% 
  mutate(FIPS = paste0(state_fips_code, county_code),
         YEAR = as.numeric(year)) %>% 
  select(YEAR, FIPS, FARMS = Value) %>% 
  left_join(farm_county)

# Net Cash Income
years <- as.character(c(2002, 2007, 2012, 2017))
nass_county <- map(years, function(x){
  nass_data(commodity_desc = "INCOME, NET CASH FARM", source_desc = "CENSUS",
            sector_desc = "ECONOMICS", agg_level_desc = "COUNTY",
            statisticcat_desc = "NET INCOME",
            year = x, numeric_vals = T)
})

farm_county <- nass_county %>% 
  bind_rows() %>% 
  mutate(FIPS = paste0(state_fips_code, county_code),
         YEAR = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("farm_net_cash",
                                        "farm_net_cash_per_farm",
                                        "junk", "farmer_net_cash",
                                        "farmer_net_cash_per_farm",
                                        "farmer_net_cash",
                                        "farmer_net_cash_per_farm")),
         short_desc = as.character(short_desc)) %>% 
  select(FIPS, Value, short_desc, YEAR) %>% 
  filter(short_desc != "junk") %>% 
  spread(short_desc, Value) %>% 
  right_join(farm_county)

# Problem writing this with write_csv ...
options(scipen = 999)
write.csv(farm_county, paste0(local_dir, "/NASS_farms_county.csv"),
          row.names = F)
write_rds(farm_county, paste0(local_dir, "/NASS_farms_county.rds"))

# ---- state level --------------------------------------------------------

years <- as.character(c(1850, 1860, 1870, 1880, 1890, 1900,
                        1910:format(Sys.Date(), "%Y")))

nass_land  <- nass_data(commodity_desc = "AG LAND", agg_level_desc = "STATE",
                        statisticcat_desc = "ASSET VALUE",
                        freq_desc = "ANNUAL",
                        numeric_vals = T)

akhi_land  <- map(c("1997", "2002", "2007", "2012", "2017"), function(x){
  nass_data(commodity_desc = "AG LAND", agg_level_desc = "STATE",
            sector_desc = "ECONOMICS", domain_desc = "TOTAL",
            statisticcat_desc = "ASSET VALUE", source_desc = "CENSUS",
            year = x, numeric_vals = T)
})

akhi <- akhi_land %>% 
  bind_rows() %>% 
  select(state = state_name, Value, short_desc, year) %>% 
  mutate(year = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("agland_total", "agland",
                                        "junk", "more_junk"))) %>% 
  filter(short_desc == "agland", state %in% c("ALASKA", "HAWAII")) %>% 
  spread(short_desc, Value) %>% 
  complete(year = full_seq(1997:format(Sys.Date(), "%Y"), 1L), state) %>% 
  group_by(state) %>% 
  fill(agland)

nass_land_data <- nass_land %>% 
  bind_rows() %>% 
  select(state = state_name, state_fips_code, Value, short_desc, year) %>% 
  mutate(year = as.numeric(year),
         short_desc = factor(short_desc,
                             labels = c("cropland", "cropland_irr",
                                        "cropland_nonirr", "agland_total",
                                        "agland", "pastureland"))) %>% 
  filter(short_desc != "agland_total", state != "OTHER STATES") %>% 
  spread(short_desc, Value) %>% 
  bind_rows(akhi) %>% 
  complete(state, year) %>% 
  arrange(state)


from_rent <- c("RENT, CASH, CROPLAND - EXPENSE, MEASURED IN $ / ACRE",
               "RENT, CASH, PASTURELAND - EXPENSE, MEASURED IN $ / ACRE",
               "RENT, CASH, CROPLAND, IRRIGATED - EXPENSE, MEASURED IN $ / ACRE",
               "RENT, CASH, CROPLAND, NON-IRRIGATED - EXPENSE, MEASURED IN $ / ACRE",
               "RENT, CASH, LAND & BUILDINGS - EXPENSE, MEASURED IN $",
               "RENT, CASH, LAND & BUILDINGS - OPERATIONS WITH EXPENSE",
               "RENT, CASH, PASTURELAND - EXPENSE, MEASURED IN $ / ACRE",
               "RENT, PER HEAD OR ANIMAL UNIT MONTH - OPERATIONS WITH EXPENSE")
to_rent   <- c("rent_cropland", "rent_pasture", "rent_irrigated",
               "rent_nonirrigated", "rent_expense",
               "operations_with_rent", "rent_pasture", "operations_head")

state_rent <- nass_data(commodity_desc = "RENT", agg_level_desc = "STATE",
                        statisticcat_desc = "EXPENSE", domain_desc = "TOTAL",
                        numeric_vals = T)

state_rent <- state_rent %>% 
  filter(short_desc %in% from_rent) %>% 
  mutate(year = as.numeric(year),
         #location_desc = gsub("OHIO, ", "", location_desc),
         short_desc = plyr::mapvalues(short_desc,
                                      from = from_rent,
                                      to = to_rent)) %>% 
  select(year, val = Value, short_desc, source_desc, domain_desc,
         state = state_name) %>% 
  spread(short_desc, val)

# Collapse the data.frame between CENSUS and SURVEY
state_rent <- state_rent %>% 
  select(-source_desc, -domain_desc) %>% 
  group_by(year, state) %>% 
  summarise_all(list(~ifelse(sum(., na.rm = T) == 0, NA, sum(., na.rm = T))))

nass_land_data <- left_join(nass_land_data, state_rent)

#######
nass_farms <-  nass_data(commodity_desc = "FARM OPERATIONS",
                         agg_level_desc = "STATE",
                         short_desc = "FARM OPERATIONS - NUMBER OF OPERATIONS",
                         source_desc = "SURVEY", domain_desc = "TOTAL",
                         numeric_vals = T)

nass_land_data <- nass_farms %>% 
  bind_rows() %>% 
  mutate(year = as.numeric(year)) %>% 
  select(year, state = state_name, farms = Value) %>% 
  distinct() %>% 
  right_join(nass_land_data)

nass_acres <- nass_data(commodity_desc = "FARM OPERATIONS",
                        agg_level_desc = "STATE",
                        short_desc = "FARM OPERATIONS - ACRES OPERATED",
                        source_desc = "SURVEY", domain_desc = "TOTAL",
                        numeric_vals = T)

nass_land_data <- nass_acres %>% 
  bind_rows() %>% 
  mutate(year = as.numeric(year)) %>% 
  select(year, state = state_name, acres = Value) %>% 
  distinct() %>% 
  right_join(nass_land_data)


# --- fred-data -----------------------------------------------------------


fred  <- FredR(api_key_fred)
gdpd  <- "GDPDEF" %>% 
  fred$series.observations(observation_start = "1947-01-01") %>% 
  select(date, deflator = value) %>% 
  mutate(year = year(date), deflator = as.numeric(deflator))
cpi   <- "CPIAUCNS" %>% 
  fred$series.observations(observation_start = "1913-01-01") %>% 
  select(date, cpi = value) %>% 
  mutate(year = year(date), cpi = as.numeric(cpi))
fred <- gdpd %>% 
  right_join(cpi) %>% 
  group_by(year) %>% 
  summarise(deflator = mean(deflator, na.rm = T), cpi = mean(cpi, na.rm = T))

nass_land_data <- left_join(nass_land_data, fred) %>% 
  group_by(state) %>% 
  fill(acres, farms, cropland, cropland_irr, cropland_nonirr, agland,
       pastureland, deflator, cpi) %>% 
  ungroup()


# write_csv(nass_land_data, paste0(local_dir, "/NASS_agland.csv"))
write.csv(nass_land_data, paste0(local_dir, "/NASS_agland.csv"),
          row.names = F)
write_rds(nass_land_data, paste0(local_dir, "/NASS_agland.rds"))
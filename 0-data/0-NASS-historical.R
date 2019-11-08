# Needs to run after 0-NASS.R, also needs icpsr_counties_1850_dd.csv in the
#  0-data/NASS folder

# Formating and interpolating the historical NASS data since 1978
# https://www.icpsr.umich.edu/icpsrweb/ICPSR/studies/35206

# ---- start --------------------------------------------------------------

library("tidyverse")
library("zoo")

na_spline <- function(y, ...) {
  if (all(is.na(y))) return(y)
  na.spline(y, ...) + 0*na.approx(y, ..., na.rm = FALSE)
}

# Set directory for the data
local_dir    <- "0-data/NASS"
if (!file.exists(local_dir)) dir.create(local_dir, recursive = T)

# ---- format -------------------------------------------------------------

# Create a full sequence of fips-years and interpolate missing Census values

historical <- read_csv("0-data/NASS/icpsr_counties_1850_dd.csv",
                       col_types = cols(.default = "d", name = "c")) %>% 
  mutate(acres_owned = acres_full_owned + acres_part_owned,
         acres_rented = acres - acres_owned)

nass_county <- read_rds("0-data/NASS/NASS_farms_county.rds") %>% 
  rename_all(~paste0(tolower(.), "_nass")) %>% 
  rename(year = year_nass, fips = fips_nass) %>% 
  mutate(fips = as.numeric(fips))

# Need to take away the weird counties
## TO DO: double check the FIPS are correct with the BLS values of FIPS

historical <- historical %>%
  filter(ctyfips < 900, year > 1977, fips != 4012) %>%
  mutate(rent_income = income_rent_val / income_rent_farms_reporting,
         cash_rent = cash_rent_val / cash_rent_farms,
         interest_per_farm = interest_val / interest_farms,
         interest_re_per_farm = interest_re_val / interest_re_farms,
         fips = if_else(fips == 12025, 12086, fips)) %>%
  select(year, fips, farms, acres, acres_owned, acres_rented, acres_irrigated,
         acres_insured, farmland_val,
         farmland_val_per_farm, farmland_val_per_acre,
         rent_income, cash_rent, net_cash_val, interest_per_farm,
         interest_re_per_farm, sales_livestock:bales_cotton)

# j5 <- full_join(historical, nass_county) %>% 
#   mutate(farms = ifelse(is.na(farms_nass), farms, farms_nass),
#          farmland_val = ifelse(is.na(agland_nass), farmland_val,
#                                agland_nass),
#          acres = ifelse(is.na(acres_nass), acres, acres_nass),
#          farmland_val_per_farm = ifelse(is.na(agland_per_farm_nass),
#                                         farmland_val_per_farm,
#                                         agland_per_farm_nass),
#          farmland_val_per_acre = ifelse(is.na(agland_per_acre_nass),
#                                         farmland_val_per_acre,
#                                         agland_per_acre_nass),
#          net_cash_val = ifelse(is.na(farm_net_cash_nass), net_cash_val,
#                                farm_net_cash_nass)) %>%
#   select(year, fips, farms, acres, acres_owned, acres_rented, acres_irrigated,
#          acres_insured, farmland_val_per_farm, farmland_val_per_acre,
#          rent_income, cash_rent, net_cash_val, interest_per_farm,
#          interest_re_per_farm, sales_livestock:bales_cotton)

# Add in a spline interpolation for values, correct for potential extrapolation
#  problems with the NAs
historical_interp <- historical %>% 
  complete(fips, year = full_seq(year,1)) %>% 
  group_by(fips) %>% 
  mutate_at(vars(-group_cols()), list(~na_spline(x = year, y = ., xout = year))) %>% 
  ungroup() %>% 
  rename_at(vars(-year, -fips), list(~paste0(., "_interp")))

# Correct for negative interpretted farms and farmland values:
historical_interp <- historical_interp %>% 
  mutate_at(vars(farms_interp:bales_cotton_interp),
            function(x) if_else(x < 0, 0, x))

# NEED TO LOOK AT ACRES AND FARMS, should be 1 or 0? problems with dividing by 0

historical <- historical %>% 
  full_join(historical_interp) %>% 
  arrange(fips, year) %>% 
  mutate(yield_corn = bushels_corn_grain / acres_corn_grain,
         yield_wheat = bushels_wheat / acres_wheat,
         yield_soybeans = bushels_soybeans / acres_soybeans,
         yield_cotton = bales_cotton / acres_cotton,
         yield_corn_interp = bushels_corn_grain_interp /
           acres_corn_grain_interp,
         yield_wheat_interp = bushels_wheat_interp / acres_wheat_interp,
         yield_soybeans_interp = bushels_soybeans_interp /
           acres_soybeans_interp,
         yield_cotton_interp = bales_cotton_interp / acres_cotton_interp)


write_csv(historical, paste0(local_dir, "/historical_interp.csv"))
write_rds(historical, paste0(local_dir, "/historical_interp.rds"))

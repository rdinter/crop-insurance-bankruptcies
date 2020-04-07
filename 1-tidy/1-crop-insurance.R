# Merging the RMA and NASS data for some sort of a crop insurance
#  participation variable

# ---- start --------------------------------------------------------------


library("stringr")
library("tidyverse")
sumn <- function(x) ifelse(all(is.na(x)), NA, sum(x, na.rm = T))
myspread <- function(df, key, value) {
  # quote key
  keyq <- rlang::enquo(key)
  # break value vector into quotes
  valueq <- rlang::enquo(value)
  s <- rlang::quos(!!valueq)
  df %>% gather(variable, value, !!!s) %>%
    unite(temp, !!keyq, variable) %>%
    spread(temp, value)
}

local_dir   <- "1-tidy/crop_insurance"
if (!file.exists(local_dir)) dir.create(local_dir)

rma   <- read_rds("0-data/RMA/sobcov.rds")
plant <- read_rds("0-data/NASS/planted.rds")

# There appears to be issues with fips being in multiple ASD in the early 80s
plant <- plant %>% 
  select(year, fips, BARLEY_impute:WHEAT) %>% 
  group_by(year, fips) %>% 
  summarise_all(sumn)

# ---- plant-manipulate ---------------------------------------------------

# Transform planted information into long form for each crop

plant_long <- plant %>% 
  ungroup() %>% 
  gather(var, val, -year, -fips)

plant_int <- plant_long %>% 
  filter(!is.na(fips)) %>% 
  separate(var, c("plant_com", "impute"), "_") %>% 
  replace_na(list(impute = "planted"))

# Need to remove: CANOLA, CHICKPEAS, MUSTARD, RYE,
#  SAFFLOWER, SWEETPOTATOES, TOMATOES
plant_int <- plant_int %>% 
  filter(!(plant_com %in% c("CANOLA", "CHICKPEAS", "MUSTARD", "RYE",
                            "SAFFLOWER", "SWEETPOTATOES", "TOMATOES")))


# It turns out, LENTILS are considered DRY PEAS, so need to correct for that
plant_peas <- plant_int %>% 
  mutate(plant_com = ifelse(plant_com ==  "LENTILS", "PEAS", plant_com)) %>% 
  filter(plant_com == "PEAS") %>% 
  group_by(year, fips, plant_com, impute) %>% 
  summarise(val = sumn(val)) %>% 
  distinct()

# Also combine sweet corn with corn
plant_corn <- plant_int %>% 
  mutate(plant_com = ifelse(plant_com ==  "SWEETCORN", "CORN", plant_com)) %>% 
  filter(plant_com == "CORN") %>% 
  group_by(year, fips, plant_com, impute) %>% 
  summarise(val = sumn(val)) %>% 
  distinct()

plant_long <- plant_int %>% 
  filter(!(plant_com %in% c("SWEETCORN", "CORN", "LENTILS", "PEAS"))) %>% 
  distinct() %>% 
  bind_rows(plant_corn, plant_peas) %>% 
  group_by(year, fips, plant_com) %>% 
  spread(impute, val) %>% 
  ungroup()


# ---- rma-manipulate -----------------------------------------------------

# Commodity and start year:
# "BARLEY" 1924 "BEANS" 1944 "CANOLA" 1999 "CORN" 1924 "COTTON" 1928
# "FLAXSEED" 1924 "LENTILS" 1999 "MUSTARD" 1999 "OATS" 1924 "PEANUTS" 1965
# "PEAS" 1972 "PEPPERS" 2017 "POTATOES" 1929 "RICE" 1953 "RYE" 1931
# "SAFFLOWER" 1999 "SORGHUM" 1940 "SOYBEANS" 1938 "SUGARBEETS" 1939
# "SUNFLOWER" 1971 "SWEET CORN" 1977 "SWEET POTATOES" 1925 "TOMATOES" 1973
# "WHEAT" 1919

# Need to remove: CANOLA, MUSTARD, RYE, SAFFLOWER, SWEETPOTATOES, TOMATOES
plant_keep <- c("BARLEY", "BEANS", "CORN", "COTTON", "FLAXSEED", "OATS",
                "PEANUTS", "PEAS", "POTATOES", "RICE", "SORGHUM",
                "SOYBEANS", "SUGARBEETS", "SUNFLOWER", "SWEETCORN", "WHEAT") #,
# "CANOLA", "MUSTARD", "RYE", "SAFFLOWER",
# "SWEETPOTATOES", "TOMATOES")

# The crossover that makes sense (above 1990): CORN (and HYBRID CORN SEED),
# WHEAT, SOYBEANS, OATS, GRAIN SORGHUM and SILAGE SORGHUM (as SORGHUM),
# BARLEY, COTTON,
# SUNFLOWERS (as SUNFLOWER), DRY BEANS (as BEANS), PEANUTS, POTATOES,
# SUGAR BEETS (as SUGARBEETS), RICE, FLAX (as FLAXSEED),
# GREEN PEAS AND DRY PEAS (as PEAS), SWEET CORN and FRESH MARKET SWEET CORN,
# RYE, TOMATOES and FRESH MARKET TOMATOES,

rma_plant <- rma %>% 
  mutate(plant_com = case_when(com_code %in% c(47, 105, 46) ~ "BEANS",
                               com_code %in% c(41, 141, 62, 341, 441) ~ "CORN",
                               com_code %in% c(21, 22, 121, 321) ~ "COTTON",
                               com_code == 31 ~ "FLAXSEED",
                               com_code %in% c(75, 175) ~ "PEANUTS",
                               com_code %in% c(67, 64) ~ "PEAS",
                               # com_code == 67 ~ "DRYPEAS",
                               # com_code == 64 ~ "GREENPEAS",
                               com_code %in% c(55, 80, 18) ~ "RICE",
                               com_code %in% c(51, 151, 50, 59) ~ "SORGHUM",
                               com_code %in% c(181, 481, 81) ~ "SOYBEANS",
                               com_code == 39 ~ "SUGARBEETS",
                               com_code == 78 ~ "SUNFLOWER",
                               com_code %in% c(44, 93, 42) ~ "CORN", #"SWEETCORN",
                               com_code %in% c(85, 156) ~ "SWEETPOTATOES",
                               com_code %in% c(86, 87) ~ "TOMATOES",
                               com_code %in% c(11, 111, 311) ~ "WHEAT",
                               T ~ com_name)) %>% 
  filter(plant_com %in% plant_keep)

# Summarise each county's information on crop insurance, notably the acreage
#  and coverage/payouts for each crop and all of them.

rma_int <- rma_plant %>% 
  group_by(year, fips, plant_com) %>% 
  summarise(covered = sumn(net_report_q),
            liability = sumn(liability_amt),
            premium = sumn(prem_amt),
            subsidy = sumn(subsidy_amt),
            indemnity = sumn(indem_amt)) %>% 
  ungroup() %>% 
  arrange(year, fips, plant_com)

rma_all <- rma_plant %>% 
  group_by(year, fips) %>% 
  summarise(covered = sumn(net_report_q),
            liability = sumn(liability_amt),
            premium = sumn(prem_amt),
            subsidy = sumn(subsidy_amt),
            indemnity = sumn(indem_amt),
            plant_com = "ALL") %>% 
  ungroup()

# rma_plant <- rma_int %>% 
#   bind_rows(rma_all)

# Need to only use the insurance information where we know planted acreage,
#  turn observations without acreage into NA

j5 <- rma_int %>% 
  full_join(plant_long) %>% 
  arrange(year, fips, plant_com) %>% 
  mutate(surveyed = case_when(!is.na(planted) ~ 1,
                              is.na(planted) & year <= max(plant$year) ~ 0,
                              T ~ NA_real_),
         survey_impute = case_when(!is.na(impute) ~ 1,
                                   is.na(impute) & year <= max(plant$year) ~ 0,
                                   T ~ NA_real_))

# Dade county issue, change 12025 to 12086
j5 <- mutate(j5, fips = ifelse(fips == 12025, 12086, fips))

write_csv(j5, paste0(local_dir, "/crop_insurance_long.csv"))
write_rds(j5, paste0(local_dir, "/crop_insurance_long.rds"))


j5_all <- j5 %>% 
  group_by(year, fips) %>% 
  summarise(covered = sumn(covered * surveyed),
            covered_impute = sumn(covered*survey_impute),
            impute = sumn(impute * survey_impute),
            planted = sumn(planted * surveyed),
            liability = ifelse(all(is.na(planted)),
                               NA_integer_, sumn(liability)),
            premium = ifelse(all(is.na(planted)),
                             NA_integer_, sumn(premium)),
            subsidy = ifelse(all(is.na(planted)),
                             NA_integer_, sumn(subsidy)),
            indemnity = ifelse(all(is.na(planted)),
                               NA_integer_, sumn(indemnity)),
            plant_com = "ALL")

# NEED to figure out how to not have survey/imputed in here
# j6 <- j5 %>% 
#   group_by()
# 
# crop_covered <- j5 %>% 
#   select(-surveyed, -survey_impute) %>% 
#   bind_rows(j5_all) %>% 
#   myspread(plant_com, c(planted, impute, covered,
#                         liability, subsidy, indemnity))

write_csv(j5_all, paste0(local_dir, "/crop_insurance.csv"))
write_rds(j5_all, paste0(local_dir, "/crop_insurance.rds"))

# ---- summary-junk -------------------------------------------------------


# Summary stats??

j5_all %>% 
  group_by(year) %>% 
  summarise(covered = sumn(covered),
            planted = sumn(planted)) %>% 
  gather(var, val, -year) %>% 
  ggplot(aes(year, val, color = var)) + geom_line()


###

huh <- j5 %>% 
  group_by(year, plant_com) %>% 
  summarise(covered = sumn(covered*surveyed),
            planted = sumn(planted*surveyed)) %>% 
  gather(var, val, -year, -plant_com) %>% 
  ggplot(aes(year, val, color = var)) +
  geom_line() +
  facet_wrap(~plant_com, scales = "free")

lemon::reposition_legend(huh, "bottom right", panel = "panel-4-4")

# j5 %>% 
#   group_by(year) %>% 
#   filter(CORN_planted > 0) %>% 
#   summarise(covered = sumn(CORN_acres),
#             acres = sumn(CORN_planted)) %>% 
#   gather(var, val, -year) %>% 
#   ggplot(aes(year, val, color = var)) + geom_line()


# spread(plant_com, -year, -fips)

# WHEAT - ACRES PLANTED: lasts from 1989 until 2008 then stops. Need to manually
#  add the spring and winter wheats together.
# Same with SUNFLOWER - ACRES PLANTED: for non-oil type and oil type
# RYE stops in 2009
# Keep BEANS, DRY EDILE - ACRES PLANTED and BEANS, SNAP, PROCESSING - ACRES PLANTED

# Easiest to keep the class_desc of the important ones then remove the wheat and
#  sunflower totals
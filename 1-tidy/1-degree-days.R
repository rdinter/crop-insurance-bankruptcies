# Degree Day tidy data
# Still need to 1) add additional data, 2) have a district level dataset, and
#  3) to verify the correct FIPS are used

# For ease of analysis, we are going to eliminate AK and HI

# Do we need to add in variables for number of establishments? Anything else?

# NOTE: are there really no observations for DC in the historical Ag Censuses?
# Answer: really, there aren't.

# ---- start --------------------------------------------------------------

library("tidyverse")
sumn <- function(x) ifelse(all(is.na(x)), NA, sum(x, na.rm = T))

local_dir   <- "1-tidy/ddays"
if (!file.exists(local_dir)) dir.create(local_dir)

fipcross <- c("29510" = 29189, "51510" = 51059, "51515" = 51019,
              "51540" = 51191, "51560" = 51005, "51570" = 51041,
              "51580" = 51005, "51590" = 51143, "51595" = 51081,
              "51600" = 51059, "51610" = 51059, "51620" = 51175,
              "51630" = 51177, "51640" = 51035, "51660" = 51165,
              "51670" = 51149, "51678" = 51163, "51683" = 51153,
              "51685" = 51153, "51690" = 51089, "51720" = 51195,
              "51730" = 51149, "51750" = 51121, "51770" = 51161,
              "51775" = 51161, "51780" = 51083, "51790" = 51015,
              "51820" = 51015, "51840" = 51069, "12025" = 12086) #,
# "4012"  = 00000, "11001" = 00000, "51520" = 00000,
# "51530" = 00000, "51535" = 00000, "51650" = 00000,
# "51680" = 00000, "51700" = 00000, "51710" = 00000,
# "51735" = 00000, "51740" = 00000, "51760" = 00000,
# "51830" = 00000)


# --- bankruptcies --------------------------------------------------------


# counties <- read_csv("0-data/uscourts/archived/f5a/f5a_goss.csv") %>% 
#   rename_all(tolower) %>% 
#   mutate(fips = if_else(fips == 12025, 12086L, fips)) %>% 
#   filter(fips < 57000, !(fips > 15000 & fips < 16000),
#          !(fips > 2000 & fips < 3000))

counties <- read_csv("0-data/uscourts/county_annual.csv") %>% 
  rename_all(tolower) %>% 
  # Look up the fips with issues and replace with correct fips code
  mutate(fips = ifelse(is.na(fipcross[as.character(fips)]),
                       fips, fipcross[as.character(fips)]),
         year = lubridate::year(date)) %>% 
  # mutate(fips = if_else(fips == 12025, 12086L, fips)) %>% 
  filter(fips < 57000, !(fips > 15000 & fips < 16000),
         !(fips > 2000 & fips < 3000))

# Collapse Dade County:
counties <- counties %>% 
  select(-date) %>% 
  group_by(year, fips) %>% 
  summarise_all(sumn)

counties <- complete(counties,
                     fips, year = full_seq(year,1))

# Problems start about here...
# match(counties$fips, names(fipcross))

districts <- read_csv("0-data/uscourts/district_counties.csv") %>% 
  ungroup() %>% 
  rename_all(tolower) %>% 
  mutate(fips = parse_number(fips)) %>% 
  filter(fips < 57000, !(fips > 15000 & fips < 16000),
         !(fips > 2000 & fips < 3000))

# ---- independent-vars ---------------------------------------------------


santana <- read_rds("0-data/degree_days/degree_days.rds") %>% 
  ungroup() %>% 
  rename_all(tolower) %>% 
  mutate(dday_good = dday10 - dday30) %>% 
  filter(fips < 57000, !(fips > 15000 & fips < 16000),
         !(fips > 2000 & fips < 3000))

fdic  <- read_rds("0-data/FDIC/county/county_branches.rds") %>% 
  ungroup() %>% 
  mutate(fips = fips_br, year = lubridate::year(date)) %>% 
  filter(fips < 57000, !(fips > 15000 & fips < 16000),
         !(fips > 2000 & fips < 3000))

unemp <- read_rds("0-data/LAU/LAU_annual.rds") %>% 
  ungroup() %>% 
  rename_all(tolower) %>% 
  filter(fips < 57000, !(fips > 15000 & fips < 16000),
         !(fips > 2000 & fips < 3000))


historical <- read_rds("0-data/NASS/historical_interp.rds") %>% 
  ungroup() %>% 
  left_join(districts) %>% 
  filter(fips < 57000, !(fips > 15000 & fips < 16000),
         !(fips > 2000 & fips < 3000))


# ---- fips ---------------------------------------------------------------

fips_counties   <- unique(counties$fips)
fips_santana    <- unique(santana$fips) # obvious interpolation problems
fips_fdic       <- unique(fdic$fips)
fips_unemp      <- unique(unemp$fips)
fips_historical <- unique(historical$fips)

# Culprit appears to be the bankruptcy courts:
setdiff(fips_counties, fips_santana) # fips_counties not in fips_santana
setdiff(fips_santana, fips_counties) # fips_santana not in fips_counties
setdiff(fips_counties, fips_fdic)
setdiff(fips_counties, fips_unemp)
setdiff(fips_counties, fips_historical)

# Here are the bankruptcy FIPS which need to be adjusted:
# [1]  2013  2016  2030  2040  2050  2060  2070  2080  2100  2120
# [11]  2130  2140  2150  2160  2164  2170  2180  2185  2188  2200
# [21]  2201  2210  2220  2230  2231  2240  2260  2261  2270  2280
# [31]  2290  4012 11001 13150 13510 24007 24510 29193 29510 40413
# [41] 51510 51515 51520 51530 51535 51540 51560 51570 51580 51590
# [51] 51595 51600 51610 51620 51630 51640 51650 51660 51670 51678
# [61] 51680 51683 51685 51690 51700 51710 51720 51730 51735 51740
# [71] 51750 51760 51770 51775 51780 51790 51820 51830 51840


# ---- joining ------------------------------------------------------------

j5 <- full_join(santana, counties)

j5 <- j5 %>% 
  left_join(historical) %>% 
  left_join(fdic) %>% 
  left_join(unemp) %>% 
  left_join(districts) %>% 
  ungroup()

j5 <- j5 %>% 
  mutate(farms = if_else(farms < 1, 1, farms),
         farms_interp = if_else(farms_interp < 1, 1, farms_interp),
         farms_forward = farms) %>% 
  group_by(fips) %>% 
  fill(farms_forward) %>% 
  ungroup()

j5 <- mutate(j5,
             pct_irrigated = acres_irrigated_interp / acres_interp,
             b_rate = 10000*chap_12 / farms_forward,
             b_rate_interp = 10000*chap_12 / farms_interp,
             agloan_d_rate = agloans_d_alt / lnag,
             agloan_re_d_rate = agloans_re_d_alt / lnreag,
             agloan_all_d_rate = (agloans_d_alt + agloans_re_d_alt) /
               (lnag + lnreag),
             agloan_d_rate_year = agloans_d_alt_year / lnag_year,
             agloan_re_d_rate_year = agloans_re_d_alt_year / lnreag_year,
             agloan_all_d_rate_year = (agloans_d_alt_year +
                                         agloans_re_d_alt_year) /
               (lnag_year + lnreag_year),
             livestock_share = sales_livestock_interp /
               (sales_livestock_interp + sales_crops_interp),
             unemp_rate = unemp / (unemp + emp))

j5 <- mutate(j5,
             pct_irrigated = case_when(pct_irrigated > 1 ~ 1,
                                       pct_irrigated < 0 ~ 0,
                                       is.infinite(pct_irrigated) ~ NA_real_,
                                       T ~ pct_irrigated))


# ---- crop-insurance -----------------------------------------------------

crop_covered <- read_rds("1-tidy/crop_insurance/crop_insurance.rds")

# j5unique  <- unique(j5$fips)
# rmaunique <- unique(crop_covered$fips)
# setdiff(j5unique, rmaunique)
# setdiff(rmaunique, j5unique)

j5 <- left_join(j5, crop_covered)



# ---- production-regions -------------------------------------------------

west    <- c("WASHINGTON", "OREGON", "CALIFORNIA", "NEVADA", "IDAHO", "UTAH",
             "MONTANA", "WYOMING", "ARIZONA", "COLORADO", "NEW MEXICO")
plains  <- c("NORTH DAKOTA", "SOUTH DAKOTA", "NEBRASKA",
             "KANSAS", "OKLAHOMA", "TEXAS")
midwest <- c("MINNESOTA", "IOWA", "MISSOURI", "WISCONSIN",
             "ILLINOIS", "INDIANA", "MICHIGAN", "OHIO")
south   <- c("ARKANSAS", "LOUISIANA", "MISSISSIPPI", "ALABAMA",
             "GEORGIA", "FLORIDA", "SOUTH CAROLINA")

j5 <- mutate(j5, production_region = case_when(state %in% west ~ "west",
                                               state %in% plains ~ "plains",
                                               state %in% midwest ~ "midwest",
                                               state %in% south ~ "south",
                                               T ~ "atlantic"))

# Trying to save space, let's just keep the 1980 onward and select variables
j6 <- j5 %>% 
  filter(year > 1979) %>% 
  select(year, fips, prec, dday8, dday10, dday30, dday32, dday34, dday_good,
         total_filings:nbchap_13,
         farms:net_cash_val,
         farms_interp:net_cash_val_interp, total_branches:deposits,
         lnag, lnreag, loans_d:agloans_re_d_alt,
         agloans_d_year:indemnity, production_region, circuit)

# PROBLEM: total_branches

write_csv(j6, paste0(local_dir, "/ddays.csv"))
write_rds(j6, paste0(local_dir, "/ddays.rds"))

# Rod bankruptcies and crop insurance participation

j5 %>% 
  filter(year > 1988) %>% 
  select(year, fips, farms, farms_forward, chap_12, b_rate,
         agloan_d_rate, agloan_re_d_rate, agloan_all_d_rate,
         covered, planted:production_region,
         prec, dday8, dday10, dday30, dday32, dday34, dday_good) %>% 
  mutate(crop_part = ifelse(covered > planted, 1, covered / planted),
         subsidy_ratio = ifelse(premium <= 0 | subsidy <= 0, 0,
                                subsidy / (subsidy + premium)),
         loss_ratio = ifelse(premium <= 0, 0, abs(indemnity / premium))) %>% 
  write_csv(paste0(local_dir, "/county_bankruptcies_insurance.csv"))

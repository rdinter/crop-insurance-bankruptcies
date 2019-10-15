# Palmer Drought Severity Index (PDSI)
# https://data.cdc.gov/Environmental-Health-Toxicology/
#  Palmer-Drought-Severity-Index-1895-2016/en5r-5ds4

# ---- start --------------------------------------------------------------

library("lubridate")
library("rvest")
library("RSocrata")
library("tidyverse")
source("0-data/0-api-keys.R")

local_dir   <- "0-data/CDC"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir, recursive = T)
if (!file.exists(data_source)) dir.create(data_source, recursive = T)
# 
# cdc_api <- "https://data.cdc.gov/resource/en5r-5ds4.csv"
# 
# download.file(cdc_api,
#               destfile = paste0(data_source, "/PDSI-", Sys.Date(), ".csv"),
#               mode = "wb")

# ---- download -----------------------------------------------------------

df <- read.socrata("https://data.cdc.gov/resource/en5r-5ds4.csv",
                   app_token = cdc_token)

write_csv(df, paste0(data_source, "/PDSI-", Sys.Date(), ".csv"))
write_rds(df, paste0(data_source, "/PDSI-", Sys.Date(), ".rds"))


# ---- aggregated ---------------------------------------------------------

# Apparently the best practice is to average the PDSI across months
agg_pdsi <- df %>% 
  mutate(date = as.Date(paste(year, month, "1", sep = "-")),
         days = days_in_month(date)) %>% 
  group_by(year, countyfips) %>% 
  summarise(pdsi = weighted.mean(pdsi, days, na.rm = T))

write_csv(agg_pdsi, paste0(local_dir, "/PDSI-",
                           format(Sys.Date(), "%Y"), ".csv"))
write_rds(agg_pdsi, paste0(local_dir, "/PDSI-",
                           format(Sys.Date(), "%Y"), ".rds"))

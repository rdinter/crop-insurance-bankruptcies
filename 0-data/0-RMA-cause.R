# RMA Cause of Loss 
# https://legacy.rma.usda.gov/data/cause


# ---- start --------------------------------------------------------------

library("httr")
library("stringr")
library("rvest")
library("tidyverse")
sumn <- function(x) sum(x, na.rm = T)

local_dir   <- "0-data/RMA"
data_source <- paste0(local_dir, "/raw/cause")
if (!file.exists(local_dir)) dir.create(local_dir, recursive = T)
if (!file.exists(data_source)) dir.create(data_source, recursive = T)

# ---- download -----------------------------------------------------------


rma_base <- "https://legacy.rma.usda.gov/data/cause"

indem_only <- rma_base %>% 
  read_html() %>% 
  html_nodes("ul:nth-child(5) li:nth-child(4) a") %>% 
  html_attr("href") %>% 
  paste0("https://legacy.rma.usda.gov", .)

map(indem_only, function(x){
  Sys.sleep(runif(1, 2, 3))
  file_x <- paste0(data_source, "/", basename(x))
  if (!file.exists(file_x)) download.file(x, file_x)
})

indem_month <- rma_base %>% 
  read_html() %>% 
  html_nodes("br~ ul li:nth-child(4) a") %>% 
  html_attr("href") %>% 
  paste0("https://legacy.rma.usda.gov", .)

map(indem_month, function(x){
  Sys.sleep(runif(1, 2, 3))
  file_x <- paste0(data_source, "/", basename(x))
  if (!file.exists(file_x)) download.file(x, file_x)
})

sob_month <- rma_base %>% 
  read_html() %>% 
  html_nodes("ul:nth-child(11) li~ li+ li a") %>% 
  html_attr("href") %>% 
  paste0("https://legacy.rma.usda.gov", .)

map(sob_month, function(x){
  Sys.sleep(runif(1, 2, 3))
  file_x <- paste0(data_source, "/", basename(x))
  if (!file.exists(file_x)) download.file(x, file_x)
})

# ---- indemnity ----------------------------------------------------------

j5 <- dir(data_source, pattern = "col_indem*", full.names = T)

indem <- c("year", "st_fips", "st_abrv", "cty_fips", "cty_name",
           "com_code", "com_name", "ins_plan", "ins_plan_name",
           "stage_code", "cause_loss_code", "cause_loss_description",
           "determined_acres", "indem_amt")

sob_map <- map(j5, function(x) {
  temp <- read_delim(x, delim = "|", col_names = indem,
                     col_types = cols(.default = "c"), quote = "")
  return(temp)
})

sob_indem <- sob_map %>% 
  bind_rows() %>% 
  mutate_at(vars(year, st_fips, cty_fips, ins_plan, cause_loss_code,
                 com_code, determined_acres, indem_amt),
            parse_number) %>% 
  mutate_at(vars(cty_name, com_name, cause_loss_description), trimws)

write_csv(sob_indem, paste0(local_dir, "/sob_indem.csv"))
write_rds(sob_indem, paste0(local_dir, "/sob_indem.rds"))

# ---- indem-mnth ----------------------------------------------------------

j5 <- dir(data_source, pattern = "col_month*", full.names = T)

indemmnth <- c("year", "st_fips", "st_abrv", "cty_fips", "cty_name",
               "com_code", "com_name", "ins_plan", "ins_plan_name",
               "stage_code", "cause_loss_code", "cause_loss_description",
               "month_loss_num", "month_loss",
               "determined_acres", "indem_amt")

sob_map <- map(j5, function(x) {
  temp <- read_delim(x, delim = "|", col_names = indemmnth,
                     col_types = cols(.default = "c"), quote = "")
  return(temp)
})

sob_indemmnth <- sob_map %>% 
  bind_rows() %>% 
  mutate_at(vars(year, st_fips, cty_fips, ins_plan, cause_loss_code,
                 com_code, month_loss_num, determined_acres, indem_amt),
            parse_number) %>% 
  mutate_at(vars(cty_name, com_name, cause_loss_description), trimws)

write_csv(sob_indemmnth, paste0(local_dir, "/sob_indemmnth.csv"))
write_rds(sob_indemmnth, paste0(local_dir, "/sob_indemmnth.rds"))

# ---- sob-cause ----------------------------------------------------------

j5 <- dir(data_source, pattern = "colsom*", full.names = T)

precause <- c("year", "st_fips", "state", "cty_fips", "cty_name", "crop_code",
              "crop_name", "ins_plan", "ins_plan_name", "cov_cat",
              "stage_code", "cause_loss_code", "cause_loss_description",
              "month_loss_num", "month_loss", "policies_prem",
              "policies_indem", "net_planted_acres", "liability", "total_prem",
              "subsidy", "indem_amt", "loss_ratio")
cause <- c("year", "st_fips", "state", "cty_fips", "cty_name", "crop_code",
           "crop_name", "ins_plan", "ins_plan_name", "cov_cat", "stage_code",
           "cause_loss_code", "cause_loss_description", "month_loss_num",
           "month_loss", "policies_prem", "policies_indem",
           "net_planted_acres", "net_endorsed_acres", "liability",
           "total_prem", "subsidy", "net_determined_acres", "indem_amt",
           "loss_ratio")

sob_map <- map(j5, function(x) {
  # temp_year <- parse_number(str_sub(x, -8, -5))
  # if (temp_year > 2000) {
  #   temp <- read_delim(x, delim = "|", col_names = cause,
  #                      col_types = cols(.default = "c"))
  # } else if (temp_year < 2001) {
  #   temp <- read_delim(x, delim = "|", col_names = precause,
  #                      col_types = cols(.default = "c"))
  # }
  temp <- read_delim(x, delim = "|", col_names = cause,
                     col_types = cols(.default = "c"), quote = "")
  return(temp)
})

sob_cause <- sob_map %>% 
  bind_rows() %>% 
  mutate_at(vars(year, st_fips, cty_fips, crop_code, ins_plan, cause_loss_code,
                 month_loss_num, policies_prem, policies_indem,
                 net_planted_acres, net_endorsed_acres, liability, total_prem,
                 subsidy, net_determined_acres, indem_amt, loss_ratio),
            parse_number) %>% 
  mutate_at(vars(cty_name, crop_name, cause_loss_description), trimws)

write_csv(sob_cause, paste0(local_dir, "/sob_cause.csv"))
write_rds(sob_cause, paste0(local_dir, "/sob_cause.rds"))
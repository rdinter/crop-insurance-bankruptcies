# RMA Summary of Business Reports - crop insurance
# https://www.rma.usda.gov/SummaryOfBusiness/StateCountyCrop

# ---- start --------------------------------------------------------------

library("httr")
library("stringr")
library("rvest")
library("tidyverse")
sumn <- function(x) sum(x, na.rm = T)

local_dir   <- "0-data/RMA"
data_source <- paste0(local_dir, "/raw/sob")
if (!file.exists(local_dir)) dir.create(local_dir, recursive = T)
if (!file.exists(data_source)) dir.create(data_source, recursive = T)

rma_base <- "https://www.rma.usda.gov/SummaryOfBusiness/StateCountyCrop"

j5 <- rma_base %>% 
  read_html() %>% 
  html_nodes(".rteContainer li~ li+ li a") %>% 
  html_attr("href") %>% 
  paste0("https://www.rma.usda.gov", .) %>% 
  # change up the file link as zip
  str_replace_all("ashx\\?la=en", "zip")
# Hack, there's a duplicate of 1982 that needs to be 1983:
j5 <- append(j5, paste0("https://www.rma.usda.gov/-/media/RMAweb/",
                        "SCC-SOB/State-County-Crop/sobscc_1983.zip"))

# ---- download -----------------------------------------------------------


map(j5, function(x){
  file_x <- paste0(data_source, "/", basename(x))
  if (!file.exists(file_x)) {
    Sys.sleep(runif(1, 2, 3))
    download.file(x, file_x)
  } 
})

coverage <- rma_base %>% 
  read_html() %>% 
  html_nodes(".col-md-12:nth-child(2) li+ li a") %>% 
  html_attr("href") %>% 
  paste0("https://www.rma.usda.gov", .) %>% 
  # change up the file link as zip
  str_replace_all("ashx\\?la=en", "zip")

map(coverage, function(x){
  file_x <- paste0(data_source, "/", basename(x))
  if (!file.exists(file_x)) {
    Sys.sleep(runif(1, 2, 3))
    download.file(x, file_x)
  }
})

type_struc <- rma_base %>% 
  read_html() %>% 
  html_nodes(".col-md-12~ .col-md-12+ .col-md-12 li+ li a") %>% 
  html_attr("href") %>% 
  paste0("https://www.rma.usda.gov", .) %>% 
  # change up the file link as zip
  str_replace_all("ashx\\?la=en", "zip")

map(type_struc, function(x){
  file_x <- paste0(data_source, "/", basename(x))
  if (!file.exists(file_x)) {
    Sys.sleep(runif(1, 2, 3))
    download.file(x, file_x)
  }
})

# ---- read ---------------------------------------------------------------

# Crop insurance Experience

sobscc_files <- dir(data_source, full.names = T, pattern = "sobscc")

scc_names1 <- c("year", "st_fips", "st_abrv", "cty_fips", "cty_name",
                "com_code", "com_name", "ins_plan", "ins_plan_name", "cov_cat",
                "pol_sold", "pol_earn_count", "pol_indem_count",
                "unit_prem_count", "unit_indem_count", "net_report_q",
                "liability_amt", "prem_amt", "subsidy_amt", "indem_amt",
                "loss_ratio")
scc_names2 <- c("year", "st_fips", "st_abrv", "cty_fips", "cty_name",
                "com_code", "com_name", "ins_plan", "ins_plan_name", "cov_cat",
                "delivery", "pol_sold", "pol_earn_count",
                "pol_indem_count", "unit_prem_count", "unit_indem_count",
                "net_report_q_type", "net_report_q", "endorse_acres",
                "liability_amt", "prem_amt", "subsidy_amt", "indem_amt",
                "loss_ratio")


j5 <- map(sobscc_files, function(x){
  temp <- read_delim(x, "|", escape_double = FALSE, col_names = FALSE,
                     trim_ws = TRUE, col_types = cols(.default = "c"))
  if (length(names(temp)) == 21) (names(temp) <- scc_names1) else (
    names(temp) <- scc_names2
  )
  return(temp)
})

sobscc <- bind_rows(j5) %>% 
  mutate_at(vars(year, st_fips, cty_fips, com_code, ins_plan, pol_sold,
                 pol_earn_count, pol_indem_count, unit_prem_count,
                 unit_indem_count, net_report_q, liability_amt, prem_amt,
                 subsidy_amt, indem_amt, loss_ratio, endorse_acres),
            parse_number) %>% 
  mutate(fips = 1000*st_fips + cty_fips)

write_csv(sobscc, paste0(local_dir, "/sobscc.csv"))
write_rds(sobscc, paste0(local_dir, "/sobscc.rds"))

# Notes: BUYUP is for all prior to 1989, then gone. In 1989, E was a category.
#  Then in 1995, E disappeared and then A/C were the dominant forms but L did
#  exist from 1995 to 2000

# # Commodities of importance
# sobscc %>% #filter(year == 2016) %>%
#   group_by(year, com_name) %>%
#   tally() %>%
#   arrange(desc(n)) %>%
#   print(n = 113)

# What are the negative indemnity values?
sobscc %>% 
  filter(indem_amt < 0) %>% 
  write.csv("double_check_RMA.csv", row.names = FALSE)

# FIPS Summaries, let's do total acres
sobscc_acres_all <- sobscc %>% 
  filter(net_report_q_type == "Acres") %>% 
  group_by(fips, year) %>% 
  summarise(acres = sumn(net_report_q),
            liability_amt = sumn(liability_amt),
            prem_amt = sumn(prem_amt),
            subsidy_amt = sumn(subsidy_amt),
            indem_amt = sumn(indem_amt))

write_csv(sobscc_acres_all, paste0(local_dir, "/sobscc_acres_all.csv"))
write_rds(sobscc_acres_all, paste0(local_dir, "/sobscc_acres_all.rds"))

# FIPS Summaries, let's do total acres
sobscc_acres_com <- sobscc %>% 
  mutate(com_name = toupper(com_name)) %>% 
  filter(net_report_q_type == "Acres") %>% 
  group_by(com_name, fips, year) %>% 
  summarise(acres = sumn(net_report_q),
            liability_amt = sumn(liability_amt),
            prem_amt = sumn(prem_amt),
            subsidy_amt = sumn(subsidy_amt),
            indem_amt = sumn(indem_amt))

write_csv(sobscc_acres_com, paste0(local_dir, "/sobscc_acres_com.csv"))
write_rds(sobscc_acres_com, paste0(local_dir, "/sobscc_acres_com.rds"))


# Experience with Coverage Level

sobcov_files <- dir(data_source, full.names = T, pattern = "sobcov")
cov_names <- c("year", "st_fips", "st_abrv", "cty_fips", "cty_name",
               "com_code", "com_name", "ins_plan", "ins_plan_name", "cov_cat",
               "delivery", "cov_lev", "pol_sold", "pol_earn_count",
               "pol_indem_count", "unit_prem_count", "unit_indem_count",
               "net_report_q_type", "net_report_q", "endorse_acres",
               "liability_amt", "prem_amt", "subsidy_amt", "indem_amt",
               "loss_ratio")

j5 <- map(sobcov_files, function(x) {
  read_delim(x, "|", escape_double = FALSE, col_names = cov_names,
             trim_ws = TRUE, col_types = cols(.default = "c"))
})

sobcov <- bind_rows(j5) %>% 
  mutate_at(vars(year, st_fips, cty_fips, com_code, ins_plan, cov_lev,
                 pol_sold, pol_earn_count, pol_indem_count, unit_prem_count,
                 unit_indem_count, net_report_q, liability_amt, prem_amt,
                 subsidy_amt, indem_amt, loss_ratio, endorse_acres),
            parse_number) %>% 
  mutate(fips = 1000*st_fips + cty_fips)

write_csv(sobcov, paste0(local_dir, "/sobcov.csv"))
write_rds(sobcov, paste0(local_dir, "/sobcov.rds"))


# Coverage level type practice

# sobtpu_files <- dir(data_source, full.names = T, pattern = "sobtpu")
# tpu_names <- c("year", "st_fips", "st_name", "st_abrv", "cty_fips",
#                "cty_name", "com_code", "com_name", "ins_plan", "ins_plan_name",
#                "cov_cat", "cov_lev", "deliv_id", "type_code", "type_name",
#                "practice_code", "practice_name", "unit_str_code",
#                "unit_str_name", "net_rep_lev_amt", "rep_lev_type",
#                "liability_amt", "prem_amt", "subsidy_amt", "indem_amt",
#                "loss_ratio", "endorse_acres")
# 
# j5 <- map(sobtpu_files, function(x) {
#   read_delim(x, "|", escape_double = FALSE, col_names = tpu_names,
#              trim_ws = TRUE, col_types = cols(.default = "c"))
# })
# 
# sobtpu <- bind_rows(j5) %>% 
#   mutate_at(vars(year, st_fips, cty_fips, com_code, ins_plan, cov_lev,
#                  type_code, practice_code, net_rep_lev_amt,
#                  liability_amt, prem_amt, subsidy_amt, indem_amt,
#                  loss_ratio, endorse_acres),
#             parse_number) %>% 
#   mutate(fips = 1000*st_fips + cty_fips)
# 
# write_csv(sobtpu, paste0(local_dir, "/sobtpu.csv"))
# write_rds(sobtpu, paste0(local_dir, "/sobtpu.rds"))
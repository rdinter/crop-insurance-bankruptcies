#######
# Local Area Unemployment 1990 to 2018
# http://www.bls.gov/lau/
# Update bls website: http://www.bls.gov/bls/ftp_migration_crosswalk.htm

# ---- start --------------------------------------------------------------


library("stringr")
library("tidyverse")
library("zoo")

# Set the years you want to download, currently for all data through current year
year1       <- 1976 #actually, they do not have county estimates before 1990.
year2       <- as.numeric(format(Sys.Date(), "%Y"))
local_dir   <- "0-data/LAU"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir, recursive = T)
if (!file.exists(data_source)) dir.create(data_source, recursive = T)

# ---- download-documentation ---------------------------------------------

urls <- "http://download.bls.gov/pub/time.series/la/"

download.file(paste0(urls,"la.txt"), paste0(local_dir, "/la.txt"))
download.file(paste0(urls,"/la.area"), paste0(local_dir, "/la.area"))
download.file(paste0(urls,"/la.area_type"), paste0(local_dir, "/la.area_type"))


# ---- download-states ----------------------------------------------------


states <- c("10.Arkansas", "11.California", "12.Colorado", "13.Connecticut",
            "14.Delaware", "15.DC", "16.Florida", "17.Georgia", "18.Hawaii",
            "19.Idaho", "20.Illinois", "21.Indiana", "22.Iowa", "23.Kansas",
            "24.Kentucky", "25.Louisiana", "26.Maine", "27.Maryland",
            "28.Massachusetts", "29.Michigan", "30.Minnesota",
            "31.Mississippi", "32.Missouri", "33.Montana", "34.Nebraska",
            "35.Nevada", "36.NewHampshire", "37.NewJersey", "38.NewMexico",
            "39.NewYork", "40.NorthCarolina", "41.NorthDakota", "42.Ohio",
            "43.Oklahoma", "44.Oregon", "45.Pennsylvania", "47.RhodeIsland",
            "48.SouthCarolina", "49.SouthDakota", "50.Tennessee", "51.Texas",
            "52.Utah", "53.Vermont", "54.Virginia", "56.Washington",
            "57.WestVirginia", "58.Wisconsin", "59.Wyoming", "7.Alabama",
            "8.Alaska", "9.Arizona")
urls  <- paste0(urls, "la.data.", states)
files <- paste(data_source, basename(urls), sep = "/")

# You need to delete the raw data to update the data, these are from the FTP
map2(urls, files, function(urls, files)
  if (!file.exists(files)) {
    Sys.sleep(runif(1, 2, 3))
    download.file(urls, files)
    })

cross <- read_tsv(paste0(local_dir, "/la.area"), skip = 1, col_names = F,
                       col_types = cols(.default = "c")) %>%
  mutate(series_id = X2, LAUS = str_sub(X2, 2, 8),
                 fips = as.numeric(str_sub(X2, 3, 7))) %>%
  filter(X1 == "F") %>% #this subsets by county
  select(series_id, LAUS, fips)

datacollect <- function(file){
  data <- read_tsv(file, col_types = "cicdc") %>%
    #mutate(value = as.numeric(value)) %>%
    #filter(year >= year1, year <= year2, period == "M13",
    filter(str_sub(series_id, 4, 18) %in% cross$series_id,
           str_sub(series_id, 19, 20) %in% c("04", "05")) %>%
    mutate(LAUS = str_sub(series_id, 5, 11),
           var = factor(str_sub(series_id, 19, 20),
                        labels = c("UNEMP", "EMP"))) %>%
    select(LAUS, year, period, value, var) %>% left_join(cross) %>%
    select(YEAR = year, period, FIPS = fips, var, value) -> data
  return(data)
}

data_temp <- map(files, datacollect)

# ---- annual -------------------------------------------------------------

unemp <- data_temp %>%
  bind_rows() %>%
  spread(var, value)

temp_2019 <- unemp %>% 
  filter(YEAR == 2019) %>% 
  group_by(FIPS) %>% 
  summarise(EMP   = round(mean(EMP, na.rm = T)),
            UNEMP = round(mean(UNEMP, na.rm = T)),
            period = "M13",
            YEAR = 2019)

unemp_annual <- unemp %>% 
  filter(period == "M13") %>% 
  bind_rows(temp_2019) %>% 
  select(-period)

write_csv(unemp_annual, paste0(local_dir, "/LAU_annual.csv"))
write_rds(unemp_annual, paste0(local_dir, "/LAU_annual.rds"))

# ---- month --------------------------------------------------------------


unemp_month <- unemp %>% 
  filter(period != "M13") %>% 
  mutate(MONTH = as.numeric(as.character(factor(period, labels = 1:12))),
         date = as.Date(paste(YEAR, MONTH, 1, sep = "/"), "%Y/%m/%d")) %>% 
  select(-period)

write_csv(unemp_month, paste0(local_dir, "/LAU_month.csv"))
write_rds(unemp_month, paste0(local_dir, "/LAU_month.rds"))

# ---- quarter ------------------------------------------------------------


unemp_quarter <- unemp_month %>% 
  mutate(date = as.Date(as.yearqtr(date, format = "%Y-%m-%d") + 0.25) - 1) %>% 
  group_by(date, FIPS) %>% 
  summarise(UNEMP = mean(UNEMP, na.rm = T),
            EMP = mean(EMP, na.rm = T))

write_csv(unemp_quarter, paste0(local_dir, "/LAU_quarter.csv"))
write_rds(unemp_quarter, paste0(local_dir, "/LAU_quarter.rds"))

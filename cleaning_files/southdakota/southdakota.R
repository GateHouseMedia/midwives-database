# install.packages("tidyverse")
# install.packages("janitor")
#install.packages("lubridate")

library(tidyverse)
library(janitor)
library(readxl)
library(lubridate)

southdakotacnms <- read_excel("CNM 110618.xlsx") %>% 
  clean_names()

southdakotanames <- southdakotacnms %>% 
  unite(name, last_name, first_name, sep=", ", remove=T)

southdakotaclean <- southdakotanames %>% 
  mutate(state_of_record = "SOUTH DAKOTA") %>% 
  mutate(known_credentials = "CERTIFIED NURSE MIDWIFE") %>% 
  mutate(data_source = "SOUTH DAKOTA BOARD OF NURSING") %>% 
  mutate(date_collected = "NOVEMBER 2018")

write_csv(southdakotaclean, "sdclean_cnms.csv")

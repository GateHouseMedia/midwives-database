#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

alabama_certifiednursemidwives <- read_excel("Copy of CNM Data 2008-2018.xlsx") %>% 
  clean_names()

clean_alabama <- alabama_certifiednursemidwives %>% 
  rename("license_number" = rn_number,
         "license_status" = status,
         "documents" = discipline) %>% 
  select(-issue_date) %>% 
  mutate(state_of_record = "ALABAMA") %>% 
  mutate(data_source = "ALABAMA BOARD OF NURSING") %>% 
  mutate(date_collected = "NOVEMBER 2018")

write_csv(clean_alabama, "clean_alabama_nursemidwives.csv")

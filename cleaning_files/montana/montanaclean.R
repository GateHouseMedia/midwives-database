#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

####MONTANA CNMS####

CLEANMONTANACNMS <- read_excel("NEWCNMS.xlsx") %>% 
  clean_names()

cleannames <- CLEANMONTANACNMS %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

cleanmontana2 <- cleannames %>% 
  mutate(state_of_record = "MONTANA") %>% 
  mutate(credential = "CERTIFIED NURSE MIDWIFE") %>% 
  mutate(data_source = "MONTANA DEPARTMENT OF LABOR AND INDUSTRY") %>% 
  mutate(date_collected = "OCTOBER 2018")

write_csv(cleanmontana2, "cleanmontanacnms.csv")

####MONTANA MIDWIVES####


CLEANMONTANAMIDWIVES <- read_excel("midwives.xlsx") %>% 
  clean_names()

cleanmidwifenames <- CLEANMONTANAMIDWIVES %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

cleanmidwifenames2 <- cleanmidwifenames %>% 
  mutate(state_of_record = "MONTANA") %>% 
  mutate(known_credentials = "STATE LICENSED MIDWIFE") %>% 
  mutate(data_source = "MONTANA DEPARTMENT OF LABOR AND INDUSTRY") %>% 
  mutate(date_collected = "NOVEMBER 2018")

cleanmidwifenames3 <- cleanmidwifenames2 %>% 
  rename("license_status" = record_status)

write_csv(cleanmidwifenames3, "cleanmontanamidwives.csv")

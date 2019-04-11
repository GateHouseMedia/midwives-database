#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

#put new one in on 11-19
northcarolina_nursemidwives <- read_excel("PART2MASTERLIST.xlsx") %>% 
  clean_names() %>% 
  rename("name" = nurse)

ncnames <- northcarolina_nursemidwives %>% 
  separate(name, into = c("firstname", "lastname"), sep = "\\s(?=\\S*?$)", remove=T, extra="merge", fill="right")

ncnames2 <- ncnames %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

ncclean <- ncnames2 %>% 
  rename("license_number" = rn_license_number,
         "license_number2" = certificate_number) %>% 
  select(-initial_approval) %>% 
  mutate(state_of_record = "NORTH CAROLINA") %>% 
  mutate(known_credentials = "CERTIFIED NURSE MIDWIFE") %>% 
  mutate(data_source = "NORTH CAROLINA BOARD OF NURSING") %>% 
  mutate(date_collected = "NOVEMBER 2018") %>% 
  mutate(documents = "")

write_csv(ncclean, "ncnursemidwivesclean.csv")      

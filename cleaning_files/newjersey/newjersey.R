#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

midwives25092 <- read_excel("2509 with discipline indicator.xlsx") %>% 
  clean_names() %>% 
  select(-full_name, -issue_date, -expiration_date, -addr_county) %>% 
  rename("license_status" = status, 
         "city" = addr_city, 
         "state" = addr_state, 
         "zip" = addr_zipcode, 
         "documents" = discipline) %>% 
  mutate(known_credentials = "STATE LICENSED MIDWIFE") %>% 
  mutate(known_credentials2 = "CERTIFIED PROFESSIONAL MIDWIFE")

clean_midwives25092 <- midwives25092 %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T) %>% 
  unite(name, name, middle_name, sep = " ", remove=T) %>% 
  unite(address, addr_line_1, addr_line_2, sep = " ", remove=T)

midwives25102 <- read_excel("2510 with discipline indicator.xlsx") %>% 
  clean_names() %>% 
  select(-full_name, -issue_date, -expiration_date, -addr_county) %>% 
  rename("license_status" = status, 
         "city" = addr_city, 
         "state" = addr_state, 
         "zip" = addr_zipcode, 
         "documents" = discipline) %>% 
  mutate(known_credentials = "CERTIFIED NURSE MIDWIFE")

clean_midwives25102 <- midwives25102 %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T) %>% 
  unite(name, name, middle_name, sep = " ", remove=T) %>% 
  unite(address, addr_line_1, addr_line_2, sep = " ", remove=T)

midwives25112 <- read_excel("2511 with discipline indicator.xlsx") %>% 
  clean_names() %>% 
  select(-full_name, -issue_date, -expiration_date, -addr_county) %>% 
  rename("license_status" = status, 
         "city" = addr_city, 
         "state" = addr_state, 
         "zip" = addr_zipcode, 
         "documents" = discipline) %>%
  mutate(known_credentials = "CERTIFIED NURSE MIDWIFE")

clean_midwives251112 <- midwives25112 %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T) %>% 
  unite(name, name, middle_name, sep = " ", remove=T) %>% 
  unite(address, addr_line_1, addr_line_2, sep = " ", remove=T)

midwives25222 <- read_excel("2522 with discipline indicator.xlsx") %>% 
  clean_names() %>% 
  select(-full_name, -issue_date, -expiration_date, -addr_county) %>% 
  rename("license_status" = status, 
         "city" = addr_city, 
         "state" = addr_state, 
         "zip" = addr_zipcode, 
         "documents" = discipline) %>% 
  mutate(known_credentials = "STATE LICENSED MIDWIFE") %>% 
  mutate(known_credentials2 = "CERTIFIED MIDWIFE")

clean_midwives25222 <- midwives25222 %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T) %>% 
  unite(name, name, middle_name, sep = " ", remove=T) %>% 
  unite(address, addr_line_1, addr_line_2, sep = " ", remove=T)

combined_NJ_allmidwives2 <- bind_rows(clean_midwives25092, clean_midwives25102, clean_midwives251112, clean_midwives25222) %>% 
  mutate(state_of_record = "NEW JERSEY") %>% 
  mutate(date_collected = "NOVEMBER 2018") %>% 
  mutate(data_source = "NEW JERSEY DIVISION OF CONSUMER AFFAIRS")

dupes_nj <- combined_NJ_allmidwives2 %>% 
  get_dupes(name)

write_csv(combined_NJ_allmidwives2, "clean_newjersey_allmidwives.csv")

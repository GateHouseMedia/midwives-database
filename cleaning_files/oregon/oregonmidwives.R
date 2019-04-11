#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

oregon_midwives <- read_csv("NEWNOVEMBER_OREGONMIDWIVES.csv") %>% 
  clean_names() %>% 
  select(-board, -license_issue_date, -license_renewal_date, -license_type, -public_record, -disclose, -mailing_address2) %>% 
  rename("license_number" = license_no,
         "lastname" = applicant_last_name, 
         "firstname" = applicant_first_name, 
         "address" = mailing_address1, 
         "city" = mailing_city,
         "state" = mailing_state,
         "zip" = mailing_postal_code) 

clean_oregonmid_names <- oregon_midwives %>% 
  unite(name, lastname, firstname, sep=", ", remove=T)

clean_oregonmidwives <- clean_oregonmid_names %>% 
  mutate(state_of_record = "OREGON") %>% 
  mutate(data_source = "OREGON HEALTH AUTHORITY") %>% 
  mutate(known_credentials = "STATE LICENSED MIDWIFE") %>% 
  mutate(date_collected = "NOVEMBER 2018") %>% 
  mutate(documents = "")

write_csv(clean_oregonmidwives, "NEWNOVEMBEROREGONMIDWIVES_clean.csv")

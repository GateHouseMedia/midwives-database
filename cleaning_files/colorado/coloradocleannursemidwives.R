#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

APN_Advanced_Practice_Nurses_All_Types_and_Statuses <- read_csv("APN_-_Advanced_Practice_Nurses-_All_Types_and_Statuses.csv")

ColoradoAPNs <- APN_Advanced_Practice_Nurses_All_Types_and_Statuses

RN_except_expired <- read_csv("RN_-_Registered_Nurse_-_All_Statuses_Minus_Expired (1).csv")

joinapns <- left_join(ColoradoAPNs, RN_except_expired, by = "Formatted Name")

joinrest2 <- joinapns %>% 
  clean_names()

filternursemidwives <- filter(joinrest2, sub_category_x == "CNM")

#countdisciplined
colorado_disciplined <- filternursemidwives %>% 
  filter(program_action_y != "")

cleancolumns <- filternursemidwives %>% 
  select(1:24, 45, 50, 54:57)

#COMBINE LAST AND FIRST NAMES
conames <- cleancolumns %>% 
  unite(name, last_name_x, first_name_x, sep = ", ", remove=T)

#COMBINE LAST+FIRST AND MIDDLE
conames2 <- conames %>% 
  unite(name, name, middle_name_x, sep = " ", remove=T)

#COMBINE ADDRESSES
coaddress <- conames2 %>% 
  unite(address, address_line_1_x, address_line_2_x, sep = " ", remove=T)

coaddress2 <- coaddress %>% 
  mutate(address = str_replace(address, " NA", ""))

cocleancolumnsagain <- coaddress2 %>% 
  select(-suffix_x, -entity_name_x, -formatted_name, -attention_x, -mail_zip_code_4_x, -county_x, -license_type_x, -sub_category_x, -license_first_issue_date_x, -license_last_renewed_date_x, -license_expiration_date_x, -specialty_x, -title_x, -degree_s_x, -case_number_y, -discipline_effective_date_y, -discipline_complete_date_y)

addcolumns <- cocleancolumnsagain %>% 
  mutate(state_of_record = "COLORADO") %>% 
  mutate(known_credentials = "CERTIFIED NURSE MIDWIFE") %>% 
  mutate(data_source = "COLORADO DEPARTMENT OF REGULATORY AGENCIES") %>% 
  mutate(data_source_link = "https://apps.colorado.gov/dora/licensing/Lookup/LicenseLookup.aspx") %>% 
  mutate(date_collected = "OCTOBER 2018") %>% 
  mutate(city2 = "") %>% 
  mutate(state2 = "") %>% 
  mutate(zip2 = "")
  
  
cogetdupes <- addcolumns %>% 
  get_dupes(name)

cocleancolumnsagain2 <- addcolumns %>% 
  rename("license_number" = license_number_x, 
         "license_status" = license_status_description_x, 
         "discipline" = program_action_y,
         "license_number2" = license_number_y, 
         "license_status2" =license_status_description_y) %>% 
  mutate_all(funs(toupper))

write_csv(cocleancolumnsagain2, "clean_newnursemidwives.csv")

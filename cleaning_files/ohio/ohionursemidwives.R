#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

ohionursemidwives <- read_excel("cnmcleaner.xlsx") %>% 
  clean_names()

ohionursemidwivespart2 <- read_excel("cnmspart2.xlsx") %>% 
  clean_names()

#clean part 2 

cleanohionursemidwivespart2 <- ohionursemidwivespart2 %>% 
  separate(applicant_full_name, into = c("firstname", "lastname"), sep = "\\s(?=\\S*?$)", remove=T, extra="merge", fill="left")

clean2ohiopart2 <- cleanohionursemidwivespart2 %>% 
  unite(name, lastname, firstname, sep = ", ", remove=T)

clean3ohiopart2 <- clean2ohiopart2 %>% 
  rename("license_number2" = endorsement_endorsement_number,
         "license_status" = status)
  
#clean part 1 names

ohionames <- ohionursemidwives %>%
  unite(name, last_name, first_name, sep = ", ", remove=T)

ohionames2 <- ohionames %>% 
  unite(name, name, middle_name, sep = " ", remove=T)

cleanohiopart1 <- ohionames2 %>% 
  rename("license_number2" = endorsement_indicator, 
         "address" = street_address_1,
         "issue_date" = first_issue_date)

bindohio_nms <- bind_rows(cleanohiopart1, clean3ohiopart2)

ohiocleanme <- bindohio_nms %>% 
  select(-sub_status, -effective_date, -issue_date, -renewal_date, -expiration_date, -county) %>% 
  mutate(state_licensed = "OHIO") %>% 
  mutate(license_type = "CERTFIED NURSE MIDWIFE") %>% 
  mutate(data_source = "OHIO DEPARTMENT OF ADMINISTRATIVE SERVICES") %>% 
  mutate(date_collected = "OCTOBER 2018") %>% 
  mutate(state_of_record = "OHIO")

write_csv(ohiocleanme, "newohionursemidwives.csv")


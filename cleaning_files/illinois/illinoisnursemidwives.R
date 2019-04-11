#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

illinois_part1 <- read_excel("NEWACTIVEMIDWIVES.xlsx") %>% 
  clean_names() %>% 
  rename("name" = contact_name)

illinois_part2 <- read_csv("NEWMIDWIVES2008-2018.csv") %>% 
  clean_names()

illinois_allcnms <- bind_rows(illinois_part1, illinois_part2)

illinois_allcnms2 <- illinois_allcnms %>%
  select(-first_issuance_date)

illinois_cleannames <- illinois_allcnms2 %>% 
  separate(name, into = c("firstname", "lastname"), sep = "\\s(?=\\S*?$)", remove=T, extra="merge", fill="right")

illinois_cleannames2 <- illinois_cleannames %>% 
  unite(name, lastname, firstname, sep=", ", remove=T)

illinois_getdupes <- illinois_cleannames2 %>% 
  get_dupes(name)

illinois_clean <- illinois_cleannames2 %>% 
  mutate(state_of_record = "ILLINOIS") %>% 
  mutate(data_source = "ILLINOIS DEPARTMENT OF FINANCIAL AND PROFESSIONAL REGULATION") %>% 
  mutate(known_credentials = "CERTIFIED NURSE MIDWIFE") %>% 
  mutate(date_collected = "NOVEMBER 2018") %>% 
  select(-apn_specialty) 

illinois_getdupes <- illinois_clean %>% 
  get_dupes(name)

write_csv(illinois_clean, "illinois_nursemidwivescleanNEW.csv")

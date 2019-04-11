#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

georgianursemidwives <- read_csv("newlicenses.csv")

clean_georgia_nursemidwives <- georgianursemidwives %>% 
  clean_names()

#CLEAN NAMES

names <- separate(clean_georgia_nursemidwives, name, into = c("firstname", "lastname"), sep = " ", remove=T, extra="merge", fill="right")

GA_names <- separate(clean_georgia_nursemidwives, name, into = c("firstname", "lastname"), sep = "(?=\\s[A-Z]([a-z]+)$)|(?=\\s[A-Z]([a-z]+)[-][A-Z]([a-z]+)$)", remove=T, extra="merge", fill="right")

GA_names1 <- GA_names %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

GA_address <- separate(GA_names1, address, into = c("address1", "address2"), sep = ",", remove=T, extra = "merge")
GA_address1 <- separate(GA_address, address2, into = c("city", "state"), sep = "(?=[A-Z]{2})", remove=T, extra = "merge")
GA_address2 <- separate(GA_address1, state, into = c("state", "zip"), sep = " ", remove=T, extra = "merge")

# Rename the new address column

GA_address3 <- GA_address2 %>% 
  rename(address = "address1")

GA_clean <- GA_address3 %>% 
  rename(first_issue_date = "issued")

GA_clean2 <- GA_clean %>% 
  rename(license_status = "status")

GAclean3 <- GA_clean2 %>% 
  select(-profession)

gaclean4 <- GAclean3 %>% 
  rename(expiration = "expires")

gaclean5 <- gaclean4 %>% 
  mutate(state_licensed = "GEORGIA") %>% 
  mutate(license_type = "CERTIFIED NURSE MIDWIFE")

write_csv(gaclean5, "cleangeorgianursemidwives.csv")

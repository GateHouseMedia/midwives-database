#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

nevadacnms <- read_excel("midwivesnevada.xlsx") %>% 
  clean_names()

#COMBINE LAST AND FIRST NAMES
nevadanames <- nevadacnms %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

nevadaclean <- nevadanames %>% 
  mutate(state_of_record = "NEVADA") %>% 
  mutate(known_credentials = "CERTIFIED NURSE MIDWIFE") %>% 
  mutate(data_source = "NEVADA STATE BOARD OF NURSING") %>% 
  mutate(date_collected = "NOVEMBER 2018") 

write_csv(nevadaclean, "cleannevadamidwives.csv")


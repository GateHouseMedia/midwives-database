# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)

#REPLACE WITH NEWEST SPREADSHEET OF ALL MIDWIVES
clean_dc_nursemidwives <- read_excel("LICENSED HEALTH PROFESSIONALS - NURSE MIDWIVES (Complete Database).xlsx", sheet = 2)

clean_dc_nursemidwives <- clean_dc_nursemidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

#Separate first and last
dc_names <- separate(clean_dc_nursemidwives, full_name, into = c("firstname", "lastname"), sep = "\\s(?=\\S*?$)", remove=T, extra="merge", fill="right")

#COMBINE LAST AND FIRST
dc_names2 <- dc_names %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

dcclean <- dc_names2 %>% 
  mutate(state_of_record = "WASHINGTON D.C.") %>% 
  mutate(data_source = "DISTRICT OF COLUMBIA DEPARTMENT OF HEALTH") %>% 
  mutate(date_collected = "NOVEMBER 2018") 

write_csv(dcclean, "clean_dc_nursemidwives.csv")

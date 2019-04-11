#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

activevirginiamidwives <- read_excel("Midwives10292018.xlsx", sheet = 4) %>% 
  clean_names()

virginia_midwife_names <- activevirginiamidwives %>% 
  unite(name, last_name, first_name, sep=", ", remove=T)

virginia_midwife_names2 <- virginia_midwife_names %>% 
  unite(name, name, middle_name, sep=" ", remove=T)

virginia_midwife_clean <- virginia_midwife_names2 %>% 
  mutate(state_of_record = "VIRGINIA") %>% 
  mutate(data_source = "VIRGINIA DEPARTMENT OF HEALTH PROFESSIONS") %>% 
  mutate(date_collected = "NOVEMBER 2018") %>% 
  mutate_all(funs(toupper))

write_csv(virginia_midwife_clean, "1182018virginiamidwives.csv")

####nursemidwives####

activevirginia_nursemidwives <- read_excel("Midwives10292018.xlsx", sheet = 5) %>% 
  clean_names()

virginia_nursemidwife_names <- activevirginia_nursemidwives %>% 
  unite(name, last_name, first_name, sep=", ", remove=T)

virginia_nursemidwife_names2 <- virginia_nursemidwife_names %>% 
  unite(name, name, middle_name, sep=" ", remove=T)

virginia_nursemidwife_clean <- virginia_nursemidwife_names2 %>% 
  mutate(state_of_record = "VIRGINIA") %>% 
  mutate(data_source = "VIRGINIA DEPARTMENT OF HEALTH PROFESSIONS") %>% 
  mutate(date_collected = "NOVEMBER 2018") %>% 
  mutate_all(funs(toupper))

write_csv(virginia_nursemidwife_clean, "1182018virginianursemidwives.csv")

# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)

#replaced with new file that includes all midwives 11/5
clean_louisianamidwives <- read_csv("all_midwives2louisiana.csv")

#clean headers
clean_louisianamidwives <- clean_louisianamidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

#Combine last and first
LA_names <- clean_louisianamidwives %>%
  unite(name, last_name, first_name, sep = ", ", remove=T)

#Combine last+first and middle name

LA_names2 <- LA_names %>% 
  unite(name, name, middle_name, sep = " ", remove = T)

laclean <- LA_names2 %>% 
  mutate(state_of_record = "LOUISIANA") %>% 
  mutate(known_credentials = "STATE LICENSED MIDWIFE") %>% 
  mutate(data_source = "LOUISIANA STATE BOARD OF MEDICAL EXAMINERS") %>% 
  mutate(date_collected = "OCTOBER 2018")

#Export

write_csv(laclean, "clean_louisianamidwives.csv")


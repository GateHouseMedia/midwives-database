#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

wyoming_midwives <- read_csv("midwives.csv") %>% 
  clean_names() %>% 
  select(-license_status)

wyomingnames <- wyoming_midwives %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

wyomingnames2 <- wyomingnames %>% 
  unite(name, name, initial, sep = " ", remove=T)

wyomingnames3 <- wyomingnames2 %>% 
  mutate(name = str_replace(name, " NA", ""))

wyomingclean <- wyomingnames3 %>% 
  mutate(state_licensed = "WYOMING", license_type = "STATE LICENSED MIDWIFE") %>% 
  mutate_all(funs(toupper))

write_csv(wyomingclean, "cleanwyomingmidwives.csv")

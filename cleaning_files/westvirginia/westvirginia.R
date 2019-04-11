#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

westvirginianursemidwives <- read_excel("Copy of Midwives past 10 yr.xlsx") %>% 
  clean_names()

wvnames <- westvirginianursemidwives %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

wvnames2 <- wvnames %>% 
  unite(name, name, middle_name, sep = " ", remove=T)

wvaddress <- wvnames2 %>% 
  unite(address, address1, address2, sep = " ", remove=T) %>% 
  mutate_all(funs(toupper))

write_csv(wvaddress, "wvnursemidwivesclean.csv")

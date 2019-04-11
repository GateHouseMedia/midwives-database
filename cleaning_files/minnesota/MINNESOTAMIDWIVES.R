#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

minnesotamidwives <- read_csv("copyminnesotamidwives.csv")

#COMBINE LAST AND FIRST NAMES
minnesotanames <- minnesotamidwives %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

#COMBINE LAST+FIRST AND MIDDLE
minnesotanames2 <- minnesotanames %>% 
  unite(name, name, middle_name, sep = " ", remove=T)

minnesotaclean <- minnesotanames2 %>% 
  rename("discipline" = disciplined)
  
minnesotanames3 <- minnesotaclean %>% 
  mutate(name = str_replace(name, " NA", ""))  

minnesotaclean2 <- minnesotanames3 %>% 
  mutate(state_of_record = "MINNESOTA") %>% 
  mutate(known_credentials = "STATE LICENSED MIDWIFE") %>% 
  mutate(data_source = "MINNESOTA BOARD OF MEDICAL PRACTICE") %>% 
  mutate(date_collected = "NOVEMBER 2018") 

write_csv(minnesotaclean2, "cleanminnesotamidiwves.csv")

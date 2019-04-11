#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

allnewyork_midwives <- X28MID

cleannewyork <- allnewyork_midwives %>% 
  rename("first_issue_date" = X1,
         "license_number" = X2,
         "lastname" = X3,
         "firstname" = X4,
         "middlename" = X5)

#COMBINE LAST AND FIRST NAMES
newyorknames <- cleannewyork %>% 
  unite(name, lastname, firstname, sep = ", ", remove=T)

#COMBINE LAST+FIRST AND MIDDLE
newyorknames2 <- newyorknames %>% 
  unite(name, name, middlename, sep = " ", remove=T)

newyorknames2$first_issue_date <- ymd(newyorknames2$first_issue_date)

addcolumnsny <- newyorknames2 %>% 
  mutate(state_of_record = "NEW YORK") %>% 
  mutate(known_credentials = "STATE LICENSED MIDWIFE") %>% 
  mutate(data_source = "NEW YORK STATE EDUCATION DEPARTMENT") %>% 
  mutate(date_collected = "OCTOBER 2018")

write_csv(addcolumnsny, "ALL_CLEAN_NYMIDIWVES.csv")  

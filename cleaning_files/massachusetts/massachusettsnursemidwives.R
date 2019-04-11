#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

mass_nursemidwives <- read_excel("cnms.xlsx")

#SEPARATE FIRST AND LAST

massnames <- separate(mass_nursemidwives, full_name, into = c("firstname", "lastname"), sep = " ", remove=T, extra="merge", fill="right")

#SEPARATE LAST AND MIDDLE
massnames2 <- separate(massnames, lastname, into = c("middlename", "lastname"), sep = " ", remove=T, extra="merge", fill="left")

#ADD FIRST AND LAST

massnames3 <- massnames2%>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

#ADD FIRST+LAST AND MIDDLE

massnames4 <- massnames3 %>% 
  unite(name, name, middlename, sep = " ", remove=T)

massnames5 <- massnames4 %>% 
  mutate(name = str_replace(name, "NA", ""))

massaddresses <- massnames5 %>% 
  unite(address, addr_line_1, addr_line_2, sep = " ", remove = T)

massaddresses2 <- massaddresses %>% 
  mutate(address = str_replace(address, "NA", "")) %>% 
  select(-addr_line_4)

massnames6 <- massaddresses2 %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

masscleanme <- massnames6 %>% 
  rename(city ="addr_city",
         county = "addr_county",
         expiration = "expiration_date",
         license_status = "license_status_name",
         state = "addr_state") %>% 
  mutate(state_licensed = "MASSACHUSETTS")

masscleanme2 <- clean.zipcodes(masscleanme$addr_zipcode)


write_csv(masscleanme, "clean_massachusetts_nursemidwives.csv")  

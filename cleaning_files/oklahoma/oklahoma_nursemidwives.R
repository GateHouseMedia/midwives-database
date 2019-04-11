#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

clean_oknursemidwives <- read_excel("Copy of L. Sherman APRN.CNM.ALL.20180802.xls")

clean_oknursemidwives <- clean_oknursemidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

oknames <- clean_oknursemidwives %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

oknames2 <- oknames %>% 
  unite(name, name, middle_name, sep = " ", remove=T)

oknames2$expiration <- ymd(oknames2$expiration)

oknames2$first_issue_date <- ymd(oknames2$first_issue_date)

okcounties <- separate(oknames2, county, into = c("county", "blank"), sep = " ", remove=T)

clean_oknursemidwives <- okcounties %>% 
  select(-blank)

okaddresses <- clean_oknursemidwives %>% 
  unite(address, addr1, addr2, addr3, sep = " ", remove = T)

okaddresses2 <- okaddresses %>% 
  mutate(address = str_replace(address, " NA", ""))

okaddress3 <- okaddresses2 %>% 
  mutate(address = str_replace(address, " NA", ""))

write_csv(okaddress3, "clean_oknursemidwives.csv")

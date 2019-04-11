# install.packages("tidyverse")
# install.packages("janitor")
#install.packages("lubridate")

library(tidyverse)
library(janitor)
library(readxl)
library(lubridate)

#cnmsfirst

cnm2011 <- read_csv("2011cnmroster.csv") %>% 
  clean_names()

cnm2012 <- read_csv("all2012cnmrosters.csv") %>% 
  clean_names

cnm2014 <- read_csv("all2014cnmrosters.csv") %>% 
  clean_names()

cnm2015 <- read_csv("all2015cnmrosters.csv") %>% 
  clean_names()

cnm2016 <- read_csv("all2016cnmrosters.csv") %>% 
  clean_names

cnm2017 <- read_csv("all2017cnmrosters.csv") %>% 
  clean_names

cnm2018 <- read_csv("all2018cnmrosters.csv") %>% 
  clean_names

all_cnm2018 <- bind_rows(cnm2011, cnm2012, cnm2014, cnm2015, cnm2016, cnm2017, cnm2018)

write_csv(all_cnm2018, "allcnm2018.csv")

clean_cnms <- read_csv("allcnms.csv")

cnmnames <- unite(clean_cnms, name, last_name, first_name, sep=", ", remove=T)

write_csv(cnmnames, ("cleancnms.csv"))

cnmdupes <- cnmnames %>% 
  get_dupes(lic_number)

#####LMS#####

lm2012 <- read_csv("2012lmroster.csv") %>% 
  clean_names()

lm2013 <- read_csv("all2013lmrosters.csv") %>% 
  clean_names()

lm2014 <- read_csv("all2014lmrosters.csv") %>% 
  clean_names()

lm2015 <- read_csv("all2015lmrosters.csv") %>% 
  clean_names()

lm2016 <- read_csv("all2016lmrosters.csv") %>% 
  clean_names()

lm2017 <- read_csv("all2017lmrosters.csv") %>% 
  clean_names()

lm2018 <- read_csv("all2018lmrosters.csv") %>% 
  clean_names()

all_lms <- bind_rows(lm2012, lm2013, lm2014, lm2015, lm2016, lm2017, lm2018)

lmnames <- unite(all_lms, name, last_name, first_name, sep=", ", remove=T)

write_csv(lmnames, "allnewmexico_lms.csv")

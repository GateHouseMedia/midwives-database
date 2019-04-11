#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

####INDIANA MIDWIVES####

clean_indianamidwives <- read_csv("indianamidwives.csv")

clean_indianamidwives <- clean_indianamidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

#SEPARATE FIRST AND LAST

indiananames <- separate(clean_indianamidwives, name, into = c("firstname", "lastname"), sep = " ", remove=T, extra="merge", fill="right")

#SEPARATE LAST AND MIDDLE
indiananames2 <- separate(indiananames, lastname, into = c("middlename", "lastname"), sep = " ", remove=T, extra="merge", fill="left")

#ADD FIRST AND LAST

indiananames3 <- indiananames2 %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

#ADD FIRST+LAST AND MIDDLE

indiananames4 <- indiananames3 %>% 
  unite(name, name, middlename, sep = " ", remove=T)

#DELETE OTHER DOCUMENTS COLUMN

indianadocs <- indiananames4 %>% 
  select(-other_documents)

#NOTE ALL MIDWIVES AS STATE LICENSED

indianastate <- indianadocs %>% 
  mutate(license_type1 = "STATE LICENSED MIDWIFE")

#REMOVE ORIGINAL LICENSE TYPE COLUMN
indianastate2 <- indianastate %>% 
  select(-license_type)

write_csv(indianastate2, "clean_indianamidwives.csv")


####INDIANA NURSE MIDWIVES####

clean_indiananursemidwives <- read_csv("indiananursemidwives.csv")

clean_indiananursemidwives <- clean_indiananursemidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

#SEPARATE FIRST AND LAST

nursemidwifenames <- separate(clean_indiananursemidwives, name, into = c("firstname", "lastname"), sep = " ", remove=T, extra="merge", fill="right")

#SEPARATE LAST AND MIDDLE
nursemidwifenames2 <- separate(nursemidwifenames, lastname, into = c("middlename", "lastname"), sep = " ", remove=T, extra="merge", fill="left")

#ADD FIRST AND LAST

nursemidwifenames3 <- nursemidwifenames2 %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

#ADD FIRST+LAST AND MIDDLE

nursemidwifenames4 <- nursemidwifenames3 %>% 
  unite(name, name, middlename, sep = " ", remove=T)

indianastatenurses <- nursemidwifenames4 %>% 
  mutate(license_type1 = "CERTIFIED NURSE MIDWIFE")

#REMOVE ORIGINAL LICENSE TYPE COLUMN
indianastatenurses2 <- indianastatenurses %>% 
  select(-license_type)

#REMOVE OTHER WEIRD COLUMNS
indianastatenurses3 <- indianastatenurses2 %>% 
  select(-violation_description, -sanction, -other_documents_melanie_ann_abner, -corydon_in_47112, -harrison, -nurse_midwife, -active, -x10_31_2019, -x11_9_2017, -x19, -x20, -x21)

#SEPARATE CITY STATE ZIP

indianastatenurses4 <- separate(indianastatenurses3, city_state_zip, into = c("city", "state"), sep = "?=/\\s[A-Z]{2}\\s", remove=T)

indianastatenurses4 <- separate(indianastatenurses3, city_state_zip, into = c("citystate", "zip"), sep = "(?=\\d+)", remove=T, extra = "merge")

indianastatenurses5 <- separate(indianastatenurses4, citystate, into = c("city", "state"), sep = "(?=\\s[A-Z]{2}\\s)", remove=T, extra = "merge")


write_csv(indianastatenurses5, "clean_indiananursemidwives.csv")

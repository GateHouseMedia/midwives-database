#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

clean_louisiananursemidwives <- read_excel("NEWCNMUSEME.xlsx", sheet = 1)

clean_louisiananursemidwives <- clean_louisiananursemidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

lanursemidwifenames <- clean_louisiananursemidwives %>% 
  unite(name, lname, fname, sep = ", ", remove=T)

lanursemidwifenames2 <- lanursemidwifenames %>% 
  unite(name, name, m_name, sep = " ", remove=T)

cleanlouisiana <- lanursemidwifenames2 %>% 
  mutate(state_of_record = "LOUISIANA") %>% 
  mutate(known_credentials = "CERTIFIED NURSE MIDWIFE") %>% 
  mutate(data_source = "LOUISIANA STATE BOARD OF NURSING") %>% 
 mutate(date_collected = "OCTOBER 2018")

write_csv(cleanlouisiana, "cleannursemidwives.csv")

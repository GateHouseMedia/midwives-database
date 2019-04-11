#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

pa_nursemidwives <- read_excel("pa_nursemidwivesuseme.xlsx", sheet = 2)

pa_nursemidwives <- pa_nursemidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

panames <- pa_nursemidwives %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)
        
panames2 <- panames %>% 
  unite(name, name, middle_name, sep = " ", remove=T)

painactivemidwives <- read_excel("inactive midwives.xlsx") %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

painactivenames <- painactivemidwives %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

painactivenames2 <- painactivenames %>% 
  unite(name, name, middle_name, sep = " ", remove=T)

pa_bind <- bind_rows(panames2, painactivenames2) %>% 
  select(-first_issue_date, -expiration)

checkdupes <- pa_bind %>% 
  get_dupes(name)

write_csv(pa_bind, "clean_pa_nursemidwives.csv")

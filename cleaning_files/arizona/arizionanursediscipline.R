#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

disciplinenames <- read_excel("az_lpnrndiscipline.xlsx", sheet=4) %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

allarizonacnms <- read_excel("arizonacnms.xlsx") %>% 
  clean_names() %>% 
  mutate_all(funs(toupper)) %>% 
  rename("name" = x_1,
         "lastname" = l_name)

allarizonacnms2 <- allarizonacnms %>% 
  unite(name, f_name, lastname, sep = " ", remove=T)

disciplinenames2 <- disciplinenames %>% 
  separate(name, into = c("lastname", "firstname"), sep = ", ", remove=T, extra="merge", fill="right")

disciplinenames3 <- disciplinenames2 %>% 
  separate(firstname, into = c("firstname", "middlename"), sep = " ", remove=T, extra="merge", fill="left")

disciplinenames4 <- disciplinenames3 %>% 
  unite(name, firstname, lastname, sep = " ", remove=T)

joinazdiscipline <- left_join(allarizonacnms2, disciplinenames4, by = "name")

write_csv(joinazdiscipline, "joinazdiscipline.csv")

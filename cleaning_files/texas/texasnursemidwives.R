#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

#REPLACED1182018
texas_cnms <- read_excel("NEWCERTIFIEDNURSEMIDWIVES.xlsx", sheet=2)

texas_cnms <- texas_cnms %>% 
  clean_names()

txnames <- texas_cnms %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

txnames2 <- txnames %>% 
  unite(name, name, middle_name, sep = " ", remove=T)

write_csv(txnames2, "cleantexasnursemidwives.csv")

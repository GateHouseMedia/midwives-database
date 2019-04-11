#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

allmidwives_wisconsin <- read_csv("07202018 Nurse Midwives.csv")

nursemidwives <- allmidwives_wisconsin %>% 
  clean_names() %>% 
  mutate_all(funs(toupper)) %>% 
  rename(cred_type_id = "license_number")

write_csv(nursemidwives, "allwisconsinmidwivesclean.csv")

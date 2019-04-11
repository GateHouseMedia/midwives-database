#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

nebraskanursemidwives <- read_csv("FINAL_NEBRASKA_NURSEMIDWIVES.csv") 
  
  
nebraskanodupes <- nebraska_nursemidwives %>% 
  group_by(name) %>% 
  mutate(license_type = paste(license_type, collapse=", "),
         license_number = paste(license_number, collapse=", ")) %>% 
  filter(row_number()==1)

write_csv(nebraskanodupes, "FINAL_NEBRASKA_NURSEMIDWIVES2.csv")
  
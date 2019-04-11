#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

utah_nursemidwives <- read_excel("cnms.xls")

utah_nursemidwives <- utah_nursemidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

clean_utah <- utah_nursemidwives %>% 
  select(-profession_name, -full_name, -docket_number, -addr_line_1, -addr_line_2, -phone, -email, -issue_date, -expiration_date) %>% 
  rename("name" = sort_name, 
         "known_credentials" = license_name, 
         "documents" = disciplinary_action, 
         "zip" = zipcode) %>% 
  mutate(state_of_record = "UTAH") %>% 
  mutate(data_source = "UTAH DIVISION OF OCCUPATIONAL AND PROFESSIONAL LICENSING") %>% 
  mutate(date_collected = "AUGUST 2018")

write_csv(clean_utah, "clean_utah_nursemidwives.csv")

#CLEANED IN EXCEL, REUPLOAD CLEANED TO CLEAN SOME MORE

clean2_utah <- read_csv("clean_utah_nursemidwives.csv")

clean3_utah <- clean2_utah %>% 
  mutate(name = str_replace(name, ",", ", "))

write_csv(clean3_utah, "clean_utah_nursemidwives2.csv")

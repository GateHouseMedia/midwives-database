# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)

michigannumbers <- read_excel("michigannursemidwives.xls", sheet = 3) %>% 
  clean_names() %>% 
  select(-x_1)

michigan_names1 <- read_csv("disciplinary_actions.csv")

michigan_names1$license_number <- as.character(michigan_names1$license_number)

michigan_names2 <- read_csv("disciplinary_actions_fails.csv")
michigan_names2$license_number <- as.character(michigan_names2$license_number)

joinnames <- full_join(michigannumbers, michigan_names2, by = "license_number")

joinnames2 <- full_join(joinnames, michigan_names1, by = "license_number")

write_csv(joinnames2, "michigan_merge.csv")

michigan_clean <- read_csv("michigan_merge.csv")

#Separate first and last
michigan_cleannames <- separate(michigan_clean, name, into = c("firstname", "lastname"), sep = "\\s(?=\\S*?$)", remove=T, extra="merge", fill="right")

michigan_cleannames2 <- michigan_cleannames %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

michigan_clean2 <- michigan_cleannames2 %>% 
  mutate(state_of_record = "MICHIGAN") %>% 
  mutate(data_source = "DEPARTMENT OF LICENSING AND REGULATORY AFFAIRS") %>% 
  mutate(data_source_link = "https://aca3.accela.com/MILARA/GeneralProperty/PropertyLookUp.aspx?isLicensee=Y&TabName=APO") %>% 
  mutate(date_collected = "JULY 2018") 

write_csv(michigan_clean2, "michigancleancnms.csv")

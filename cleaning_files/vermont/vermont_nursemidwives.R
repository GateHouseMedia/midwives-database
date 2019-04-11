#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

#library(tidyverse)
#library(janitor)
#library(readxl)
#library(here)
#library(lubridate)

vermont_nurse_midwives <- read_excel("all_cnms.xlsx", sheet = 2)

vermont_nurse_midwives <- vermont_nurse_midwives %>% 
  clean_names()

vermontnames <- separate(vermont_nurse_midwives, formatted_name, into = c("first_name", "last_name"), sep = "(?=\\s[A-Z]([a-z]+)$)|(?=\\s[A-Z]([a-z]+)[-][A-Z]([a-z]+)$)", remove=T, extra = "merge")

vermontnames2 <- vermontnames %>%
  unite(name, last_name, first_name, sep = ", ", remove=T)

vermontclean <- vermontnames2 %>% 
  rename(first_issue_date = "license_first_issuance_date",
         expiration = "license_expiration",
         license_status = "status") %>%
  select(-license_effective_date) %>% 
  mutate(state_licensed = "Vermont") %>% 
  mutate(license_type = "Certified Nurse Midwife")

cnms_discipline <- read_excel("cnm_discipline.xlsx")

cnms_discipline <- cnms_discipline %>% 
  clean_names()

disciplinemerge <- full_join(vermontclean, cnms_discipline, by = "license_number")

write_csv(disciplinemerge, "clean_certifiednursemidwives.csv")

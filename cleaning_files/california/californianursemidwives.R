# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)

#SWAPPED WITH NEW AND CORRECT FILE ON 11/5

clean_california_nursemidwives <- read_excel("NMW LISTING REVISED.xlsx", sheet = 2)

####ALL CALI NURSE MIDWIVES####

clean_california_nursemidwives <- clean_california_nursemidwives %>% 
  clean_names() 

#COMBINE LAST AND FIRST NAMES
calinursemidwifenames <- clean_california_nursemidwives %>% 
  unite(name, last_name, first_name, sep = ", ", remove=T)

clean_california_nursemidwives <- calinursemidwifenames

#EXPORT CLEANED NURSE MIDWIVES

write_csv(clean_california_nursemidwives, "clean_california_nursemidwives.csv")

#####CALIFORNIA NURSE MIDWIVES DISCIPLINE####

california_nursemidwives_discipline <- read_excel("disciplined_nursemidwives.xlsx")

#CLEAN COLUMN HEADS

cleancali_nursemidwives_discipline <- california_nursemidwives_discipline %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

#CLEAN NAMES

disciplinenames <- separate(cleancali_nursemidwives_discipline, rn_name, into = c("firstname", "lastname"), sep = " ", remove=T, extra="merge", fill="right")

disciplinenames2 <- disciplinenames %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

#PREP FOR MERGE

#MAKE COLUMN NAMES MATCH
disciplinenames3 <- disciplinenames2 %>% 
  rename(license_number = "rn_number")

#CREATE DISCIPLINE COLUMN AND ENTER 'YES' FOR ALL IN SPREADSHEET

disciplinenames4 <- disciplinenames3 %>% 
  mutate(discipline = "YES")

#CREATE STATE_LICENSED COLUMN IN ALL NURSES LIST TO MATCH FINAL DATABASE

clean_california_nursemidwives <- clean_california_nursemidwives %>% 
  mutate(state_licensed = "CALIFORNIA")

#RENAME NAME COLUMN IN DISCIPLINE SO IT DOESNT DO WEIRD THINGS WHEN MERGING

disciplinenames5 <- disciplinenames4 %>% 
  rename(name2 = "name")

#MERGE

calinursemidwives_withdiscipline <- full_join(clean_california_nursemidwives, disciplinenames5, by="license_number")

#DELETE EXTRA COLUMNS

calinursemidwives_withdiscipline <- calinursemidwives_withdiscipline %>% 
  select(-name2, -nmw_mwf_number)



#EXPORT MERGED FILE

write_csv(calinursemidwives_withdiscipline, "calinursemidwives_withdiscipline.csv")

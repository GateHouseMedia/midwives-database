#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

#JOIN LICENSE NAMES TO CERTIFICATIONS

tp_certifications2 <- tp_certifications %>% 
  filter(pro_cde == "1701" | pro_cde == "1711")

floridalicensees <- full_join(licensee_profile, tp_certifications2, by = "lic_id")

#FILTER TO GET JUST NURSES

floridanurses <- floridalicensees %>% 
  filter(rank_desc == "Advanced Practice Registered Nurse" | rank_desc == "Adv Reg Nurse Practitioner" | is.na(rank_desc))

#FILTER TO GET JUST NURSE MIDWIVES

floridanursemidwives <- filter(floridanurses, specialty_cert == "CERTIFIED NURSE MIDWIFE")

floridanursemidwives <- floridanursemidwives %>% 
  clean_names()

#CLEAN NAMES

floridanursenames <- floridanursemidwives %>% 
  unite(name, l_name, f_name, sep = ", ", remove=T)

floridanursenames2 <- floridanursenames %>% 
  unite(name, name, m_name, sep = " ", remove = T)

#DELETE COLUMNS I DON'T NEED

floridanurseclean <- floridanursenames2 %>% 
  select(-addr_line1, -addr_line2, -addr_city, -addr_state, -addr_zip, -cnty, -pl2_addr_line1, -pl2_addr_line2, -pl2_addr_city, -pl2_addr_state, -pl2_addr_zip, -pl2_cnty, -pl3_addr_line1, -pl3_addr_line2, -pl3_addr_city, -pl3_addr_state, -pl3_addr_zip, -pl3_cnty, -ml_cnty, -lic_sta_cde, -lic_actv_sta_cde, -lic_actv_sta_desc, -rank_cde, -yr_began_practice, -rec_id, -specialty_brd)

#CLEAN WEIRD CHARACTERS OUT OF ADDRESSES

floridanursesclean2 <- floridanurseclean %>% 
  mutate(address = str_replace(ml_addr_line1, "\\*\\*\\* NOT AVAILABLE \\*\\*\\*", " "))

floridanursesclean3 <- floridanursesclean2 %>% 
  mutate(address2 = str_replace(ml_addr_line2, "\\*\\*\\* NOT AVAILABLE \\*\\*\\*", " "))

floridanursesclean4 <- floridanursesclean3 %>% 
  mutate(city = str_replace(ml_addr_city, "\\*\\*\\*\\*\\*\\*", " "))

floridanursesclean5 <- floridanursesclean4 %>% 
  mutate(state = str_replace(ml_addr_state, "\\*\\*", " "))

floridanursesclean6 <- floridanursesclean5 %>% 
  mutate(zip = str_replace(ml_addr_zip, "\\*\\*\\*\\*\\*", " "))

#IMPORT RN DISCIPLINE FILE

RN_discipline <- read_csv("RN_discipline.csv")

#JOIN WITH RN DISCIPLINE license number in the APRN file is the same as license ID in the RN discipline file

floridalicensees_withdiscipline <- left_join(floridanursesclean6, RN_discipline, by = c("lic_nbr"="lic_id"))

#REMOVE ANYONE WITH A LICENSE NUMBER OF ZERO

floridalicensees_withdiscipline1 <- floridalicensees_withdiscipline %>% 
  filter(lic_nbr != 0) %>% 
  clean_names()

#REMOVE MORE COLUMNS I DON'T NEED

fl_discipline <- floridalicensees_withdiscipline1 %>% 
  select(-pro_cde_x, -name_suffix, -ml_addr_line1, -ml_addr_line2, -ml_addr_city, -ml_addr_state, -ml_addr_zip, -x6)

fl_discipline2 <- fl_discipline %>% 
  unite(address, address, address2, sep = " ", remove=T)

#EXPORT MIDWIVES WITH DISCIPLINE FILE

write_csv(fl_discipline2, "florida_cnms_detaileddiscipline.csv")

#check for duplicates

florida_cnm_discipline_dupes <- fl_discipline2 %>% 
  get_dupes(lic_nbr)

#REMOVE DETAILED DISCIPLINE COLUMNS

clean_cnms_florida <- fl_discipline2 %>% 
  select(-profession, -county -case_number, -action_date)

write_csv(clean_cnms_florida, "clean_cnms_florida.csv")

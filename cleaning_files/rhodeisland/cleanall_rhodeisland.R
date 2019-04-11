#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

all_rhodeisland <- read_excel("AP18-0722.xlsx", sheet = 2)

names <- separate(all_rhodeisland, full_name, into = c("firstname", "lastname"), sep = "\\s(?=\\S*?$)", remove=T, extra="merge", fill="left")

names2 <- names %>% 
  unite(name, lastname, firstname, sep = ", ", remove=T)

write_csv(names2, "NODUPESALLRHODEISLANDMIDWIVES.csv")

ziprhodeisland <- names2 %>% 
  mutate(zip = str_pad(zip, 5, side="left", pad="0"))

getridupes <- names2 %>% 
  get_dupes(license_number)

# #ri_nodupes <- getridupes %>% 
#   group_by(name) %>% 
#   mutate(known_credentials = paste(known_credentials, collapse=", "),
#          license_number = paste(license_number, collapse=", "), 
#          city = paste(city, collapse=", "), 
#          state = paste(state, collapse=", "),
#          zip = paste(zip, collapse=", "), 
#          license_status = paste(license_status, collapse=", ")
#   ) %>% 
#   filter(row_number()==1)

# licensenumbers <- separate(ri_nodupes, license_number, into = c("license_number", "license_number2", "licensenumber3"), sep = ", ", remove=T, extra="merge", fill="right")
# 
# city <- separate(licensenumbers, city, into =c("city", "city2", "city3"), sep =", ", remove=T, extra="merge", fill="right") 
# 
# known_credentials <- separate(city, known_credentials, into =c("known_credentials", "known_credentials2", "known_credentials3"), sep =", ", remove=T, extra="merge", fill="right") 
# 
# state <- separate(known_credentials, state, into =c("state", "state2", "state3"), sep =", ", remove=T, extra="merge", fill="right")
# 
# zip <- separate(state, zip, into =c("zip", "zip2", "zip3"), sep =", ", remove=T, extra="merge", fill="right")
# 
# licensestatus <- separate(zip, license_status, into =c("license_status", "license_status2", "license_status3"), sep =", ", remove=T, extra="merge", fill="right")
# 
# riclean <- licensestatus %>% 
#   select(-dupe_count)

#write_csv(riclean2, "RICLEANALLMIDWIVES.csv")

# dupe_names <- getridupes$name

# all_rhodeisland_minusdupes <- names2 %>% 
#   filter(!(name %in% dupe_names))
# 
# cleanrhodeislandmidwives <- bind_rows(riclean, all_rhodeisland_minusdupes)

write_csv(cleanrhodeislandmidwives, "CLEANRHODEISLAND_ALLMIDWIVES.csv")

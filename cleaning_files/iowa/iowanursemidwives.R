# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)

#Import file

format_iowa_nursemidwives <- read_excel("CNMLISTwithdiscipline.xlsx", sheet = 2)

#Clean headers

format_iowa_nursemidwives <- format_iowa_nursemidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

#Clean names

#Combine last and first
IA_names <- format_iowa_nursemidwives %>%
  unite(name, lname, fname, sep = ", ", remove=T)

#Combine last+first and middle name

IA_names2 <- IA_names %>% 
  unite(name, name, mname, sep = " ", remove = T)

#Limit zip codes to five digits 

fivedigitzip <- IA_names2 %>% 
  separate(zip, into = c("zip", "zip2"), sep = "-", remove=T)

#Delete column with additional zip digits

fivedigitzip2 <- fivedigitzip %>% 
  select(-zip2)

#Convert file name

clean_format_iowa_nursemidwives <- fivedigitzip2

#Export

write_csv(clean_format_iowa_nursemidwives, "clean_format_iowa_nursemidwives.csv")  

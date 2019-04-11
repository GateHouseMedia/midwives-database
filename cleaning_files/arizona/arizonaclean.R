# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)

#Import file

format_arizonamidwives <- read_csv("editedmidwives.csv")
View(format_arizonamidwives)

#Clean headers

format_arizonamidwives <- format_arizonamidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))
View(format_arizonamidwives)

#Clean names

#Separate first and last
AZ_names <- separate(format_arizonamidwives, name, into = c("firstname", "lastname"), sep = " ", remove=T, extra="merge", fill="right")

#Separate last and middle
AZ_names2 <- separate(AZ_names, lastname, into = c("middlename", "lastname"), sep = " ", remove=T, extra="merge", fill="left")

#Add together first and last

AZ_names3 <- AZ_names2 %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

#Add together first+last and middle

AZ_names4 <- AZ_names3 %>% 
  unite(name, name, middlename, sep = " ", remove=T)

#Convert file name

clean_edited_midwives <- AZ_names4

#Export

write_csv(clean_edited_midwives, "clean_edited_midwives.csv")

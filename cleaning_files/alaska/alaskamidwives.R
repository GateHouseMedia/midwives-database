#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)


alaskamidwives <- read_excel("alaskamidwives.xlsx", sheet = 2)

alaska_cleannames <- alaskamidwives %>% 
  separate(name, into = c("firstname", "lastname"), sep = "\\s(?=\\S*?$)", remove=T, extra="merge", fill="right")

alaska_cleannames2 <- alaska_cleannames %>% 
  unite(name, lastname, firstname, sep=", ", remove=T)

write_csv(alaska_cleannames2, "cleanalaskamidwives.csv")

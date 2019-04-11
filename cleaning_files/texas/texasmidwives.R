# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)

texasmidwives <- read_excel("ALLMIDWIVES.xlsx")

texasmidwives_discipline <- read_excel("MIDWIFEDISCIPLINE.xlsx")

texasmidwives_clean <- texasmidwives %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

texasmidwives_discipline_clean <- texasmidwives_discipline %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

#Combine last and first in all midwives file
TX_names <- texasmidwives_clean %>%
  unite(name, lastname, firstname, sep = ", ", remove=T)

#Combine last and first in discipline file
TX_discipline_names <- texasmidwives_discipline_clean %>% 
  unite(name, lastname, firstname, sep = ", ", remove=T)

LA_names3 <- LA_names2 %>% 
  mutate(name = str_replace(name, "NA", ""))
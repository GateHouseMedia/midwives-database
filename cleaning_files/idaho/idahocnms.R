#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

idaho_certifiednursemidwives <- read_excel("COPY OF APRN CNM_all_active_inactive_20181001.xlsx", sheet = 2) %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

idahocnmnames <- idaho_certifiednursemidwives %>% 
  unite(name, last_name, first_name, sep=", ", remove=T)

write_csv(idahocnmnames, "cleanidahonursemidwives.csv")

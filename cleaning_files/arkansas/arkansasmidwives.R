#install.packages("lubridate")
# install.packages("here")
# install.packages("tidyverse")
# install.packages("janitor")

library(tidyverse)
library(janitor)
library(readxl)
library(here)
library(lubridate)

cleanmidwives <- read_csv("arkansasmidwivesdirty.csv") %>% 
  clean_names() %>% 
  rename("license_number" = "x2") %>% 
  mutate_all(funs(toupper))

arkdupes <- get_dupes(cleanmidwives, name)

write_csv(arkdupes, "arkdupes.csv")

arkansascleanonlydupes <- read_csv("FINAL_ARKANSAS_MIDWIVES.csv")

ar_dupe_names <- arkdupes$name

arkansas_minusdupes <- cleanmidwives %>% 
  filter(!(name %in% ar_dupe_names))

arkansas_unique <- cleanmidwives %>% 
  distinct(name, .keep_all=T)

dupes_nodupes_arkansas <- bind_rows(arkansascleanonlydupes, arkansas_minusdupes)

write_csv(dupes_nodupes_arkansas, "FINAL_ARKANSAS_MIDWIVES.csv")

### COLORADO ### 

# Load files 

CO_directentry <- read_csv("co_directentry_midwives.csv")
CO_intravenous <- read_csv("co_midwife_intravenous.csv")
CO_medication <- read_csv("co_midwife_medication.csv")

# Seems like we need to clean up the directentry table first because the hyperlink has accidnetally been split over three columns
# We can also make everything uppercase while we're at it

CO_directentry_clean <- CO_directentry %>% 
  clean_names() %>% 
  unite(verification_link, verification_link, test, x31, sep = "", remove=T) %>% 
  mutate_all(funs(toupper))

# Now let's clean the intravenous midwives table

CO_intravenous_clean <- CO_intravenous %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

# Finally let's clean the medication midwives table 

CO_medication_clean <- CO_medication %>% 
  clean_names() %>% 
  mutate_all(funs(toupper))

# Bind all of them together

CO_combined <- bind_rows(CO_directentry_clean, CO_intravenous_clean, CO_medication_clean)

# There are some wonky things going on with the addresses so I'm gonna skip it for now

# Combine the first and middle name into a new column called "first_and_middle"

CO_names <- CO_combined %>% 
  unite(first_and_middle, first_name, middle_name, sep = " ", remove=T)

# Get rid of the "NA"s that appeared when we combined the columns

#CO_names2 <- CO_names %>% 
  #mutate(first_and_middle2 = str_replace(first_and_middle, " NA", ""))

# Combined the first_and_middle2 and last names, with last names in front, and delete useless columns

CO_names2 <- CO_names %>% 
  unite(name, last_name, first_and_middle, sep = ", ", remove=T)

CO_names3 <- CO_names2 %>% 
  select(-suffix, -formatted_name)

# Here is how to find dupes

CO_dupes <- get_dupes(CO_names3, name)

# Let's give the dupes one row only, by smushing together their multiple license types and license numbers into one cell each

CO_nodupes <- CO_names3 %>% 
  group_by(name) %>% 
  mutate(license_type = paste(license_type, collapse=", "),
         license_number = paste(license_number, collapse=", ")
         ) %>% 
  filter(row_number()==1) %>%
  mutate(state_licensed = "COLORADO")

write_csv(CO_nodupes, "clean_co_midwives.csv")




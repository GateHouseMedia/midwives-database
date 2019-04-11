md_nursemidwives <- read_csv("marylandnursemidwives.csv")

clean_md_names <- md_nursemidwives %>% 
  unite(name, lastname, firstname, sep=", ", remove = T)

write_csv(clean_md_names, "FINAL_MARYLAND_NURSEMIDWIVES.csv")

library(ggmap)
library(tidyverse)
library(janitor)
library(tigris)
library(sf)

### CLEAN AND GEOCODE MIDWIVES DATA ### 
# import file cleaned up in OpenRefine
cleaned_slm_for_quickhit <- read_csv("cleaned_slm_for_quickhit.csv", 
                                       col_types = cols(address2 = col_character(), 
                                                              alias = col_character(), alias2 = col_character(), 
                                                              city2 = col_character(), city3 = col_character(), 
                                                              facility = col_character(), known_credentials3 = col_character(), 
                                                              known_credentials5 = col_character(), 
                                                              license_number2 = col_character(), 
                                                              license_number3 = col_character(), 
                                                              license_number4 = col_character(), 
                                                              license_status2 = col_character(), 
                                                              license_status3 = col_character(), 
                                                              license_status4 = col_character(), 
                                                              notes = col_character(), previous_name = col_character(), 
                                                              state = col_character(), state2 = col_character(), 
                                                              state3 = col_character(), state_of_record_1 = col_character(), 
                                                              x = col_character(), zip = col_character(), 
                                                              zip2 = col_character(), zip3 = col_character()))

clean_slm <- cleaned_slm_for_quickhit %>% 
  select(name, state_of_record, license_status, license_number, address, city, state, zip, documents, data_source, data_source_link, date_collected) %>% 
  filter(license_status == "ACTIVE" | license_status == "ACTIVE - RESTRICTED" | license_status == "ACTIVE - WITH CONDITIONS" | license_status == "ACTIVE ON PROBATION" | license_status == "ACTIVE WITH CONDITIONS" | license_status == "ACTIVE/OPERATING" | license_status == "APPL IN PROCESS" | license_status == "CLEAR/ACTIVE" | license_status == "CURRENT" | license_status == "CURRENT / ACTIVE" | license_status == "CURRENT ACTIVE" | license_status == "DELINQUENT/ACTIVE" | license_status == "LICENSED" | license_status == "OBLIGATIONS/ACTIVE" | license_status == "SUSPENDED/ACTIVE" | license_status == "PENDING APPLICATION" | license_status == "PENDING") %>% 
  filter(!is.na(city)) 

# read in the unlicensed/trade group midwives file
qh_self_reported_midwives <- read_csv("self-reportedmidwivesforquickhit.csv")

# clean up and create a column that says they're self-reported for binding purposes
clean_self_reported_midwives <- qh_self_reported_midwives %>% 
  mutate_all(funs(toupper)) %>% 
  mutate(self_reported = "Y") %>% 
  filter(!is.na(city))

# bind the two
all_slms <- bind_rows(clean_slm, clean_self_reported_midwives)

#create a locations variable 
all_slms_locations <- all_slms %>%
  mutate(location = case_when(is.na(address) & is.na(zip) ~ paste0(city, ", ", state),
                            is.na(address) ~ paste0(city, ", ", state, " ", zip),
                            is.na(zip) ~ paste0(city, ", ", state),
                            TRUE ~ paste0(address, " ", city, ", ", state, " ", zip)))

# removing apartment numbers structured like "# 000" from cells for geocoding reasons
all_slms_locations[26, 15] = "40 HARRISON STREET NEW YORK, NY 10013"
all_slms_locations[54, 15] = "255 CARROLL AVENUE NW WASHINGTON, DC 20012"
all_slms_locations[55, 15] = "255 CARROLL AVENUE NW WASHINGTON, DC 20012"
all_slms_locations[68, 15] = "21010 SOUTHBANK STREET STERLING, VA 20165"
all_slms_locations[118, 15] = "213 N BOUNDARY STREET WILLIAMSBURG, VA 23185"
all_slms_locations[172, 15] = "732 NORTH HALIFAX AVENUE DAYTONA BEACH, FL 32118"
all_slms_locations[230, 15] = "3150 NORTH WICKHAM ROAD MELBOURNE, FL 32934"
all_slms_locations[241, 15] = "2000 JEFFERSON STREET HOLLYWOOD, FL 33020"
all_slms_locations[243, 15] = "10955 SW 15TH STREET PEMBROKE PINES, FL 33025"
all_slms_locations[316, 15] = "2930 IMMOKALEE ROAD NAPLES, FL 34110"
all_slms_locations[317, 15] = "2930 IMMOKALEE ROAD NAPLES, FL 34110"
all_slms_locations[318, 15] = "2930 IMMOKALEE ROAD NAPLES, FL 34110"
all_slms_locations[327, 15] = "2575 N TOLEDO BLADE BOULEVARD NORTH PORT, FL 34289"
all_slms_locations[332, 15] = "16810 S US 441 SUMMERFIELD, FL 34491"
all_slms_locations[373, 15] = "1429 WOODCREEK AVENUE MUSKEGON, MI 49441"
all_slms_locations[382, 15] = "1043 GRAND AVENUE SAINT PAUL, MN 55105"
all_slms_locations[389, 15] = "1117 WEST FRANKLIN AVE. MINNEAPOLIS, MN 55405"
all_slms_locations[415, 15] = "810 4TH AVENUE S MOORHEAD, MN 56560"
all_slms_locations[502, 15] = "1305 S JEFFERSON AVENUE MOUNT PLEASANT, TX 75455"
all_slms_locations[572, 15] = "12850 JONES ROAD HOUSTON, TX 77070"
all_slms_locations[639, 15] = "806 S 12TH STREET MCALLEN, TX 78501"
all_slms_locations[676, 15] = "3508 S 1ST STREET AUSTIN, TX 78704"
all_slms_locations[684, 15] = "6280 MCNEIL DRIVE AUSTIN, TX 78729"
all_slms_locations[707, 15] = "2230 VETERANS BOULEVARD EAGLE PASS, TX 78852"
all_slms_locations[714, 15] = "5261 PRIVATE ROAD BAIRD, TX 79504"
all_slms_locations[730, 15] = "130 TOBIN PLACE EL PASO, TX 79905"
all_slms_locations[749, 15] = "1880 SOUTH PIERCE STREET LAKEWOOD, CO 80232"
all_slms_locations[877, 15] = "408 CASCADE AVENUE HOOD RIVER, OR 97031"
all_slms_locations[879, 15] = "11257 SE STEVENS ROAD HAPPY VALLEY, OR 97086"
all_slms_locations[920, 15] = "2532 SANTIAM HIGHWAY SE ALBANY, OR 97322"
all_slms_locations[924, 15] = "701 N 5TH STREET LEBANON, OR 97355"
all_slms_locations[938, 15] = "190 OAK STREET ASHLAND, OR 97520"
all_slms_locations[967, 15] = "11517 OLD GLEN HIGHWAY EAGLE RIVER, AK 99577"
all_slms_locations[2962, 15] = "8945 MAIN STREET LEIGHTON, AL 35646"

# geocode
geo <- mutate_geocode(all_slms_locations, location)

# remove unnecessary location (APO, AP)
geo <- geo[-c(24), ]

geo[983, 15] = "19806"
geo("19806")
geo[983, 16] = "-75.6"
geo[983, 17] = "39.8"
geo <- geo_with_edits[-c(1793), ]
geo[2962, 15] = "3474 HIGHWAY 11 PELHAM, AL 35124"
geo("3474 HIGHWAY 11 PELHAM, AL 35124")
geo[2962, 16] = "-86.8"
geo[2962, 17] = "33.3"
geo[2964, 15] = "500 MAIN AVENUE SW CULLMAN, AL 35055"
geo("500 MAIN AVENUE SW CULLMAN, AL 35055")
geo[2964, 16] = "-86.8"
geo[2964, 17] = "34.2"
geo[2963, 15] = "3013 DEBRA DRIVE FULTONDALE, AL 35068"
geo("3013 DEBRA DRIVE FULTONDALE, AL 35068")
geo[2963, 16] = "-86.8"
geo[2963, 17] = "33.6"

write_csv(geo_with_edits, "geocoded_obstetric_desert_midwife_data.csv")

# find counties without a midwife
options(tigris_class = "sf")

us <- counties(state=NULL, cb=T) %>% 
  filter(STATEFP != 78,
         STATEFP != 72,
         STATEFP != 69, 
         STATEFP != 66,
         STATEFP != 60,
         STATEFP != 02,
         STATEFP != 04,
         STATEFP != 17,
         STATEFP != 18,
         STATEFP != 19,
         STATEFP != 21,
         STATEFP != 31,
         STATEFP != 33,
         STATEFP != 37,
         STATEFP != 38,
         STATEFP != 39,
         STATEFP != 42,
         STATEFP != 53, 
         STATEFP != 54)

midwives_spatial <- geo_with_edits %>%  
  st_as_sf(coords=c("lon", "lat"), crs = "+proj=longlat") %>% 
  st_transform(crs=st_crs(us)) #transform your points

points_in <- st_join(us, midwives_spatial, left = F) 

points_tibble <- points_in %>% 
  as_tibble() #change points data into a table

counties_without <- anti_join(us, points_tibble, by = c("NAME", "STATEFP")) %>% 
  select(STATEFP, NAME, GEOID, AFFGEOID, COUNTYFP, geometry) 

### GEOCODE HOSPITAL DATA ###

obstetric_hospitals <- read_csv("obstetric_care_hospitals_updated.csv") %>% 
  clean_names()

# remove american samoa and puerto rico
obstetric_hospitals <- obstetric_hospitals[-c(1:7), ]

# create a location variable 
obstetric_hospitals_locations <- obstetric_hospitals %>%
  mutate(location = str_c(address_1_physical, " ", city_name_physical, ", ", state_physical, " ", zip_code_physical))

geo_hospitals <- mutate_geocode(obstetric_hospitals_locations, location)

# find counties without a midwife
hospital_spatial <- geo_hospitals %>%  
  st_as_sf(coords=c("lon", "lat"), crs = "+proj=longlat") %>% 
  st_transform(crs=st_crs(us)) 

hospital_points_in <- st_join(us, hospital_spatial, left = F) 

hospital_points_tibble <- hospital_points_in %>% 
  as_tibble()

hospital_counties_without <- anti_join(us, hospital_points_tibble, by = c("NAME", "STATEFP")) %>% 
  select(STATEFP, NAME, GEOID, AFFGEOID, COUNTYFP) %>%  
  filter(STATEFP != 78,
         STATEFP != 72,
         STATEFP != 69, 
         STATEFP != 66,
         STATEFP != 60,
         STATEFP != 02,
         STATEFP != 04,
         STATEFP != 17,
         STATEFP != 18,
         STATEFP != 19,
         STATEFP != 21,
         STATEFP != 31,
         STATEFP != 33,
         STATEFP != 37,
         STATEFP != 38,
         STATEFP != 39,
         STATEFP != 42,
         STATEFP != 53, 
         STATEFP != 54)

### GEOCODE BIRTH CENTER DATA ###
birthcenters <- read_csv("birthcenters-db.csv")

birthcenter_locations <- birthcenters %>%
  mutate(location = case_when(is.na(address) & is.na(zip) ~ paste0(city, ", ", state),
                              is.na(address) ~ paste0(city, ", ", state, " ", zip),
                              is.na(zip) ~ paste0(address, " ", city, ", ", state),
                              TRUE ~ paste0(address, " ", city, ", ", state, " ", zip)))


birthcentergeo <- mutate_geocode(birthcenter_locations, location)

birthcentergeo[40, 21] = "7611 JORDAN LANDING BOULEVARD WEST JORDAN, UT 84085"
geocode("7611 JORDAN LANDING BOULEVARD WEST JORDAN, UT 84085")
birthcentergeo[40, 22] = "-112"
birthcentergeo[40, 23] = "40.6"
birthcentergeo[108, 21] = "12850 JONES ROAD HOUSTON, TX 77070"
geocode("12850 JONES ROAD HOUSTON, TX 77070")
birthcentergeo[108, 22] = "-95.6"
birthcentergeo[108, 23] = "30.0"
birthcentergeo[332, 21] = "930 MLK JR BOULEVARD CHAPEL HILL, NC 27514"
geocode("930 MLK JR BOULEVARD CHAPEL HILL, NC 27514")
birthcentergeo[332, 22] = "-79.1"
birthcentergeo[332, 23] = "35.9"

# find birth centers without a midwife
birthcenters_spatial <- birthcentergeo %>%  
  st_as_sf(coords=c("lon", "lat"), crs = "+proj=longlat") %>% 
  st_transform(crs=st_crs(us)) #transform your points

birthcenter_points_in <- st_join(us, birthcenters_spatial, left = F)

birthcenter_points_tibble <- birthcenter_points_in %>% 
  as_tibble()

birthcenter_counties_without <- anti_join(us, birthcenter_points_tibble, by = c("NAME", "STATEFP")) %>% 
  select(STATEFP, NAME, GEOID, AFFGEOID, COUNTYFP) 

# counties without birth centers and hospitals 
hospitalsforbind <- geo_hospitals2 %>% 
  select(hospital_name, lon, lat) %>% 
  rename(name = "hospital_name") %>% 
  mutate(lon = as.character(lon)) %>% 
  mutate(lat = as.character(lat))

birthcentersforbind <- birthcentergeo %>% 
  select(name, lon, lat) %>% 
  mutate(lon = as.character(lon)) %>% 
  mutate(lat = as.character(lat))

hospitals_birthcenters <- bind_rows(hospitalsforbind, birthcentersforbind)

hospitalbirthcenters_spatial <- hospitals_birthcenters %>%  
  st_as_sf(coords=c("lon", "lat"), crs = "+proj=longlat") %>% 
  st_transform(crs=st_crs(us)) #transform your points

hospitalbirthcenter_points_in <- st_join(us, hospitalbirthcenters_spatial, left = F) 

hospitalbirthcenter_points_tibble <- hospitalbirthcenter_points_in %>% 
  as_tibble() 

hospitalbirthcenter_counties_without <- anti_join(us, hospitalbirthcenter_points_tibble, by = c("NAME", "STATEFP")) %>% 
  select(STATEFP, NAME, GEOID, AFFGEOID, COUNTYFP) %>% 
  filter(STATEFP != 78,
         STATEFP != 72,
         STATEFP != 69, 
         STATEFP != 66,
         STATEFP != 60,
         STATEFP != 02,
         STATEFP != 04,
         STATEFP != 17,
         STATEFP != 18,
         STATEFP != 19,
         STATEFP != 21,
         STATEFP != 31,
         STATEFP != 33,
         STATEFP != 37,
         STATEFP != 38,
         STATEFP != 39,
         STATEFP != 42,
         STATEFP != 53, 
         STATEFP != 54)

# counties without midwives, hospital and birth centers
midwivesforbind <- geo_with_edits %>%
  select(name, lon, lat)
  
midwives_hospitals_birthcenters <- bind_rows(hospitalsforbind, birthcentersforbind, midwivesforbind)

midwiveshospitalbirthcenters_spatial <- midwives_hospitals_birthcenters %>%  
  st_as_sf(coords=c("lon", "lat"), crs = "+proj=longlat") %>% 
  st_transform(crs=st_crs(us)) #transform your points

midwiveshospitalbirthcenter_points_in <- st_join(us, midwiveshospitalbirthcenters_spatial, left = F) 

midwiveshospitalbirthcenter_points_tibble <- midwiveshospitalbirthcenter_points_in %>% 
  as_tibble() #change points data into a table

midwiveshospitalbirthcenter_counties_without <- anti_join(us, midwiveshospitalbirthcenter_points_tibble, by = c("NAME", "STATEFP")) %>% 
  select(STATEFP, NAME, GEOID, AFFGEOID, COUNTYFP) %>%
  filter(STATEFP != 78,
         STATEFP != 72,
         STATEFP != 69, 
         STATEFP != 66,
         STATEFP != 60,
         STATEFP != 02,
         STATEFP != 04,
         STATEFP != 17,
         STATEFP != 18,
         STATEFP != 19,
         STATEFP != 21,
         STATEFP != 31,
         STATEFP != 33,
         STATEFP != 37,
         STATEFP != 38,
         STATEFP != 39,
         STATEFP != 42,
         STATEFP != 53, 
         STATEFP != 54)

#####################################################
##
##     Assign US tracts by Place
##
#####################################################

## Prepare workspace
source("scripts/00_preamble.R")


## Set inputs
##-----------------------------------------------

## states to include
st <- "USA"  # all states
# st <- "GA"  # one state

## set place year (vintages need to be >= 2011)
place_yr <- 2021  # with 2020, getting errors with some states; recommend 2021

## set tract year (vintages need to be >= 2011)
tract_yr <- 2018  # for 2010 vintages, choose any year 2015-2019



##------------------------------------------
## import inputs
##------------------------------------------

## set states
states <- fips_codes %>%
  select(state) %>%
  distinct() %>%
  as_tibble() %>%
  # remove territories / colonial possessions
  filter(!state %in% c("AS", "GU", "MP", "PR", "VI", "UM")) %>%
  print()


## set counties
counties <- fips_codes %>%
  as_tibble() %>%
  # remove territories / colonial possessions
  filter(!state %in% c("AS", "GU", "MP", "PR", "VI", "UM")) %>%
  #mutate(COUNTYID = paste0(state_code, county_code)) %>%
  select(state, state_code, county, county_code) %>%
  rename(
    STATE = 1,
    STATEID = 2,
    COUNTY = 3,
    COUNTYID = 4
  ) %>%
  print()


## load census legal codes
codes <- read.xlsx("input_tables/census_legal_codes.xlsx") %>%
  as_tibble() %>%
  select(-3) %>%
  print()


##------------------------------------------------
## Load places + tracts data
##------------------------------------------------

if(st == "USA"){
  
  places <- NULL
  tracts <- NULL
  for(i in states$state){
    
    tryCatch({  # missing places in some years
      
      temp_pl <- tigris::places(state = i, year = place_yr, cb = TRUE)
      places <- bind_rows(temp_pl, places)
      
    }, error = function(e){})
      
      temp_tr <- tigris::tracts(state = i, year = tract_yr, cb = TRUE)
      tracts <- bind_rows(temp_tr, tracts)  
  }
  
  } else{
    
    places <- tigris::places(state = st, year = place_yr, cb = TRUE)
    
    tracts <- tigris::tracts(state = st, year = tract_yr, cb = TRUE)
    
  }


##------------------------------------------------------
## Tract / Place Centroid Overlay
##------------------------------------------------------

## tract_by_place_prep
tracts_by_place <- st_centroid(tracts) %>%
  st_join(places, suffix = c(".x", "")) %>%
  print()


## for single state --> check map
#mapview(places, col.regions = "gray60") + 
#  mapview(tracts_by_place, cex = 2, col.regions = "darkred")


## final cleaning
tracts_by_place_centroid <- tracts_by_place %>%
  as_tibble() %>%
  left_join(codes, by = "LSAD") %>%
  rename(
    STATEID = STATEFP.x,
    COUNTYID = COUNTYFP,
    TRACTID = GEOID.x,
    PLACEID = PLACEFP,
    PLACE = NAME
  ) %>%
  left_join(counties, by = c("STATEID", "COUNTYID")) %>%
  # NHGIS version
  mutate(
    NHGISID = 
      paste0(
        "G",
        str_sub(TRACTID, 1, 2),
        "0",
        str_sub(TRACTID, 3, 5),
        "0",
        str_sub(TRACTID, 6, 11)
      )
  ) %>%
  select(STATE, COUNTY, TRACTID, NHGISID, PLACEID, PLACE, PLACE_TYPE) %>%
  # include tract and place vintages
  mutate(
    TR_VINTAGE = ifelse(tract_yr < 2020, "2010", "2020"),
    PL_VINTAGE = place_yr
  ) %>%
  arrange(NHGISID) %>%
  print()


##--------------------------------------
## Save out
##--------------------------------------

## create folder
#dir.create("file_download")

## prep output
tract_out <- ifelse(tract_yr < 2020, "2010", "2020")
filename <- paste0("tracts_by_place_centroid", "_", st, "_t", tract_out, "_p", place_yr)


## save out
##--------------------------------

## xlsx
write.xlsx(tracts_by_place_centroid, paste0("file_download/", filename, ".xlsx"))

## csv
write_csv(tracts_by_place_centroid, paste0("file_download/", filename, ".csv"))


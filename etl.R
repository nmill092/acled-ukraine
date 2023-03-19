pacman::p_load("dplyr", "readr", "readxl", "jsonlite", "here")

acled_data <- readxl::read_xlsx(here::here("data/latest.xlsx"))

ua <- acled_data %>%
  filter(COUNTRY == "Ukraine" & as.Date(EVENT_DATE) >= as.Date("2022-02-23")) %>% select(EVENT_DATE, YEAR, EVENT_ID_CNTY, EVENT_TYPE, SUB_EVENT_TYPE, FATALITIES, ACTOR1, ASSOC_ACTOR_1,ACTOR2,ASSOC_ACTOR_2, ADMIN1, ADMIN2, ADMIN3, LOCATION, LATITUDE, LONGITUDE, SOURCE, NOTES, TIMESTAMP)

ua_summed <- ua %>%
  group_by(EVENT_DATE, ADMIN1, EVENT_TYPE) %>%
  summarize(incidents = n(), fatalities = sum(FATALITIES, na.rm=T)) %>%
  filter(!is.na(ADMIN1))

jsonlite::minify(jsonlite::toJSON(ua_summed,auto_unbox = T)) %>%
  readr::write_file(here("ua_latest-summed.json"),append = F)

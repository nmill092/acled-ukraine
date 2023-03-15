pacman::p_load("dplyr", "readxl", "jsonlite", "here")

acled_data <- readxl::read_xlsx(here::here("data/Ukraine_Black_Sea_2020_2023_Mar10.xlsx"))

ua <- acled_data %>%
  filter(COUNTRY == "Ukraine" & as.Date(EVENT_DATE) >= as.Date("2022-02-23")) %>% select(EVENT_DATE, YEAR, EVENT_ID_CNTY, EVENT_TYPE, SUB_EVENT_TYPE, FATALITIES, ACTOR1, ASSOC_ACTOR_1,ACTOR2,ASSOC_ACTOR_2, ADMIN1, ADMIN2, ADMIN3, LOCATION, LATITUDE, LONGITUDE, SOURCE, NOTES, TIMESTAMP)

jsonlite::toJSON(ua %>%
                   group_by(EVENT_ID_CNTY, EVENT_DATE, ADMIN1, EVENT_TYPE) %>%
                   summarize(incidents = n(), fatalities = sum(FATALITIES, na.rm=T))) %>%
  write_file("~/Desktop/ua_3-10-23-summed.json")

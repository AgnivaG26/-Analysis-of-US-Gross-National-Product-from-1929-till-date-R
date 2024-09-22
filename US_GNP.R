if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, httr, lubridate, hrbrthemes, janitor, jsonlite, fredr,
               listviewer, usethis)
theme_set(hrbrthemes::theme_ipsum())
endpoint = "series/observations"
params = list(
  api_key= "YOUR_FRED_KEY", ## Change to your own key
  file_type="json",
  series_id="GNPCA"
)
fred =
  httr::GET(
    url = "https://api.stlouisfed.org/", 
    path = paste0("fred/", endpoint), 
    query = params 
  )
fred =
  fred %>%
  httr::content("text") %>% 
  jsonlite::fromJSON() 
typeof(fred)
jsonedit(fred, mode = "view") 
fred =
  fred %>%
  purrr::pluck("observations") %>% 
  as_tibble() 
fred
fred =
  fred %>%
  mutate(across(realtime_start:date, ymd)) %>%
  mutate(value = as.numeric(value))
fred %>%
  ggplot(aes(date, value)) +
  geom_line() +
  scale_y_continuous(labels = scales::comma) +
  labs(
    x="Date", y="2012 USD (Billions)",
    title="US Real Gross National Product", caption="Source: FRED"
  )

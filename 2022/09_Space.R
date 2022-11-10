
## Tidytuesday Radio Stations / 30DayMapChallenge Space  

suppressMessages(library(tidyverse))
library(showtext)
library(sf)

font_add_google(name = "Space Grotesk", family = "font")
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)

options(timeout = max(300, getOption("timeout")))
download.file("ftp://ftp.fcc.gov/pub/Bureaus/MB/Databases/fm_service_contour_data/FM_service_contour_current.zip",
              destfile = "2022/FM_service_contour_current.zip",
              mode = "wb")

raw_contour <- read_delim(
 "./2022/FM_service_contour_current.zip",
 delim = "|"
)

conv_contour <- raw_contour |>
  select(-last_col()) |>
  set_names(nm = c(
    "application_id", "service", "lms_application_id", "dts_site_number", "transmitter_site",
    glue::glue("deg_{0:360}")
  )) %>% select(-starts_with("deg_")) %>% 
  mutate(application_id = as.numeric(application_id)) %>% 
  separate(
    transmitter_site, 
    into = c("site_lat", "site_long"), 
    sep = " ,") %>% 
  mutate(site_lat = as.numeric(site_lat),
         site_long = as.numeric(site_long))

conv_contour %>%
  filter(site_lat >= 23, site_lat <= 52) %>%
  ggplot() +
  geom_point(
    aes(x = site_long, y = site_lat),
    size = .7,
    colour = "orange",
    alpha = .3
  ) +
  geom_point(aes(x = site_long, y = site_lat),
             size = 0.05,
             colour = "yellow") +
  labs(title = str_to_upper("American FM transmitter sites by night seen from space"),
       caption = "Data: www.fcc.gov") +
  coord_map("conic", lat0 = 30) +
  theme_void() +
  theme(
    text = element_text(family = "font"),
    plot.background = element_rect(fill = "black"),
    plot.title.position = "plot",
    plot.title = element_text(colour = "orange",
                              hjust = 0.5),
    plot.caption = element_text(colour = "orange")
  )

ggsave(here::here("2022", "09_Space.png"),
       width = 6, height = 5, dpi = 300, bg = "black",
       device = "png")

fs::file_delete("./2022/FM_service_contour_current.zip")

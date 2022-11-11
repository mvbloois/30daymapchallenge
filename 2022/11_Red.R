library(osmdata)
library(ggplot2)
library(stringr)
library(showtext)

# fonts
font_add_google(name = "Noto Serif", family = "font")
#showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)

# 2.488403,49.464554,6.646729,51.505323
b_box <- getbb("Mahattan")
b_box <- matrix(c(2.488403,6.646729,49.464554,51.505323),
                byrow = TRUE,
                nrow = 2, ncol = 2,
                dimnames = list(c('x','y'),c('min','max')))


boundaries <- b_box %>%
  opq(timeout = 159) %>%
  add_osm_feature(key = "admin_level",
                  value = "2") %>%
  osmdata_sf()

fire_stations <- b_box %>%
  opq(timeout = 999) %>%
  add_osm_feature(key = "amenity",
                  value = "fire_station") %>%
  osmdata_sf()

roads <- b_box %>% opq() %>% add_osm_feature(key = "highway") %>% osmdata_sf()

ggplot() +
  geom_sf(data = boundaries$osm_lines) +
  coord_sf(xlim = c(b_box[1], b_box[3]), 
           ylim = c(b_box[2], b_box[4]),
           default_crs = sf::st_crs(4326),
           expand = FALSE) 
  
  
  geom_sf(data = fire_stations$osm_point,
         colour = "#CE2029",
         size = 0.2) +
  labs(title = "FIRE STATIONS IN BELGIUM",
       subtitle = "#30daymapchallenge",
       caption = "@martijnvanbloois@fosstodon.org | © OpenStreetMap contributors") +
+
  theme_void() +
  theme(
    text = element_text(family = "font",
                        colour = "#CE2029"),
    plot.title = element_text(size = 36,
                              hjust = 0.5),
    plot.title.position = "plot",
    plot.subtitle = element_text(size = 20,
                                 hjust = 0.5),
    plot.caption = element_text(size = 16,
                                hjust = 0.5),
    plot.background = element_rect(fill = "grey95", colour = "grey5")
  ) 

ggsave(here::here("2022", "11_Red.png"),
       width = 10, height = 8, dpi = 300,
       device = "png")


curl::curl_symbols('CURL_HTTP_VERSION_')

library(dplyr)
library(osmdata)
library(ggplot2)
library(stringr)
library(showtext)
library(rnaturalearth)

ctrs <- c("Netherlands", "Germany", "Belgium", "Luxembourg", "France")

world_map <- ne_countries(scale = 50, returnclass = 'sf')
europe_map <- world_map %>% filter(name %in% ctrs)
be_map <- world_map %>% filter(name == "Belgium")

# fonts
font_add_google(name = "Noto Serif", family = "font")
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)


# 2.488403,49.464554,6.646729,51.505323
b_box <- matrix(c(1.576538,7.036743,49.206832,51.954422),
                byrow = TRUE,
                nrow = 2, ncol = 2,
                dimnames = list(c('x','y'),c('min','max')))

fire_stations <- b_box %>%
  opq(timeout = 999) %>%
  add_osm_feature(key = "amenity",
                  value = "fire_station") %>%
  osmdata_sf()

ggplot() +
  geom_sf(data = europe_map) +
  geom_sf(data = be_map, fill = "#c1e1c1") +
  geom_sf(data = fire_stations$osm_point,
         colour = "#CE2029",
         shape = 15,
         size = 0.9) +
  labs(title = "FIRE STATIONS IN BELGIUM",
       subtitle = "#30daymapchallenge",
       caption = "@martijnvanbloois@fosstodon.org | © OpenStreetMap contributors") +
  coord_sf(xlim = c(b_box[1], b_box[3]), 
           ylim = c(b_box[2], b_box[4]),
           default_crs = sf::st_crs(4326),
           expand = FALSE) +
  theme_void() +
  theme(
    text = element_text(family = "font",
                        colour = "#CE2029"),
    plot.title = element_text(size = 36,
                              face = "bold",
                              hjust = 0.5),
    plot.title.position = "plot",
    plot.subtitle = element_text(size = 20,
                                 hjust = 0.5),
    plot.caption = element_text(size = 16,
                                hjust = 0.5)
  ) 

ggsave(here::here("2022", "11_Red.png"),
       width = 10, height = 8, dpi = 300, bg = "white",
       device = "png")



library(osmdata)
library(ggplot2)
library(stringr)
library(showtext)

# fonts
font_add_google(name = "Contrail One", family = "font")
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)

# city
city <- "Bordeaux"

city_bb <- getbb(city)


center <- colMeans(t(city_bb))

title <- str_to_upper(city)
subtitle <- paste0(round(center[2], 2), "°N", round(center[1], 2), "°W\n\n")

roads <- city_bb %>%
  opq() %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()

railways <- city_bb %>%
  opq() %>%
  add_osm_feature(key = "railway") %>%
  osmdata_sf()

map <- ggplot() +
  geom_sf(data = roads$osm_lines,
          colour = "gray20") +
  geom_sf(data = railways$osm_lines,
          colour = "gray10") +
  labs(title = title,
       subtitle = subtitle,
       caption = "Source: OpenStreetMap contributers\n@martijnvanbloois@fosstogon.org") +
  coord_sf(xlim = c(city_bb[1], city_bb[3]), 
           ylim = c(city_bb[2], city_bb[4]),
           expand = FALSE) +
  theme_void() +
  theme(text = element_text(family = "font"),
        plot.title = element_text(face = "bold",
                                  size = 24,
                                  hjust = 0.5),
        plot.subtitle = element_text(size = 14,
                                     hjust = 0.5)
  )

ggsave(paste0("./2022/13_5_Minute_Map.png"),
       map,
       width = 5, height = 6, dpi = 300,
       device = "png")

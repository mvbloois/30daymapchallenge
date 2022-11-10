
library(osmdata)
library(ggplot2)
library(stringr)
library(showtext)

# fonts
font_add_google(name = "Crimson Pro", family = "font")
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)

# city
city <- "Amsterdam"

city_bb <- getbb(city)
city_bb[1,1] <- 4.874582
city_bb[1,2] <- 4.949598
city_bb[2,1] <- 52.356784
city_bb[2,2] <- 52.393935



center <- colMeans(t(city_bb))

title <- str_to_upper(city)
subtitle <- "Buildings, parks and water"

city_buildings <- city_bb %>%
  opq() %>%
  add_osm_feature(key = "building") %>%
  osmdata_sf()

city_rivers <- city_bb %>%
  opq() %>%
  add_osm_feature(key = "waterway",
                  value = c("river", "canal")) %>%
  osmdata_sf()

city_water <- city_bb %>%
  opq() %>%
  add_osm_feature(key = "natural",
                  value = "water") %>%
  osmdata_sf()

city_parks <- city_bb %>%
  opq() %>%
  add_osm_feature(key = "leisure",
                  value = "park") %>%
  osmdata_sf()

ggplot() +
  geom_sf(data = city_parks$osm_polygons, 
          size = 0.1,
          colour = "#78ab78",
          fill = "#78ab78"
  ) +
  geom_sf(data = city_buildings$osm_polygons, 
          size = 0.1,
          colour = "#f5dbdf",
          fill = "#f5dbdf"
          ) +
  geom_sf(data = city_rivers$osm_lines,
           colour = "#7fc0ff", alpha = 0.6) +
  geom_sf(data = city_water$osm_polygons, 
          colour = "#7fc0ff",
          fill = "#7fc0ff") +
  geom_sf(data = city_water$osm_multipolygons, 
          colour = "#7fc0ff",
          fill = "#7fc0ff") +
  labs(title = title,
       subtitle = subtitle,
       caption = "Source: OpenStreetMap contributers\n@martijnvanbloois@fosstogon.org") +
  coord_sf(xlim = c(city_bb[1], city_bb[3]), 
           ylim = c(city_bb[2], city_bb[4]),
           expand = FALSE) +
  theme_void() +
  theme(text = element_text(family = "font",
                            colour = "#6a5a00"),
        plot.title = element_text(face = "bold",
                                  size = 24,
                                  hjust = 0.5),
        plot.subtitle = element_text(size = 14,
                                     hjust = 0.5),
        plot.margin = margin(0,1,1.2,1, unit = "cm"),
        plot.background = element_rect(fill = "#FCF5E5",
                                       colour = "#FCF5E5")
  )

ggsave(paste0("./maps/08_OpenStreetMap.png"),
       map,
       width = 6, height = 6, dpi = 300,
       device = "png")
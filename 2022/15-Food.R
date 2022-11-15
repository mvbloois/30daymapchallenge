library(tidyverse)
library(janitor)
library(rnaturalearth)
library(rnaturalearthdata)

world <- ne_countries(scale = "medium", returnclass = "sf")

df <- read_csv("2022/data/bananas_FAOSTAT_data_en_11-13-2022.csv") %>% 
  clean_names() %>% 
  filter(element == "Production") %>% 
  filter(area != "China") %>% 
  mutate(area = case_when(area == "China, mainland" ~ "China",
                          area == "China, Taiwan Province of" ~ "Taiwan",
                          area == "United States of America" ~ "United States",
                          area == "Bolivia (Plurinational State of)" ~ "Bolivia",
                          area == "Iran (Islamic Republic of)" ~ "Islamic Republic of Iran",
                          area == "Lao People's Democratic Republic" ~ "Lao PDR",
                          area == "Micronesia (Federated States of)" ~ "Federated States of Micronesia",
                          area == "Türkiye" ~ "Turkey",
                          TRUE ~ area
                          )) %>% 
  group_by(area) %>% 
  summarise(production = sum(value, na.rm = TRUE),
            .groups = "drop") %>% 
  slice_max(production, n = 30)

df %>% 
  arrange(desc(production)) %>% 
  mutate(perc = production/sum(production)) %>% 
  mutate(cs = cumsum(perc)) %>% view()


green <- "#38bc1c"
yellow <- "#ffe135"

world %>% 
  left_join(df, by = c("name_long" = "area")) %>% 
  ggplot() +
  geom_sf(aes(fill = production)) +
  scale_fill_gradient(low = green,
                      high = yellow, 
                      na.value = "grey95") +
  theme_void() +
  theme(legend.position = "bottom")

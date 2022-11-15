library(tidyverse)
library(janitor)
library(rnaturalearth)
library(rnaturalearthdata)
library(showtext)

# fonts
font_add_google(name = "Karla", family = "font")
showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)

world <- ne_countries(scale = "medium", returnclass = "sf")

df <- read_csv("2022/data/bananas_FAOSTAT_data_en_11-13-2022.csv") %>% 
  clean_names() %>% 
  filter(element == "Production") %>% 
  filter(area != "China") %>% 
  mutate(area = case_when(area == "China, mainland" ~ "China",
                          area == "China, Taiwan Province of" ~ "Taiwan",
                          area == "United States of America" ~ "United States",
                          area == "Bolivia (Plurinational State of)" ~ "Bolivia",
                          area == "Islamic Republic of Iran" ~ "Iran (Islamic Republic of)",
                          area == "Lao People's Democratic Republic" ~ "Lao PDR",
                          area == "Micronesia (Federated States of)" ~ "Federated States of Micronesia",
                          area == "Türkiye" ~ "Turkey",
                          area == "United Republic of Tanzania" ~ "Tanzania",
                          area == "Viet Nam" ~ "Vietnam",
                          area == "Venezuela (Bolivarian Republic of)" ~ "Venezuela",
                          area == "Cabo Verde" ~ "Cape Verde",
                          area == "Congo" ~ "Republic of Congo",
                          area == "Eswantini" ~ "Swaziland",
                          area == "Sao Tome and Principe" ~ "São Tomé and Principe",
                          area == "Syrian Arab Republic" ~ "Syria",
                          TRUE ~ area
                          )) %>% 
  group_by(area) %>% 
  summarise(production = sum(value, na.rm = TRUE),
            .groups = "drop") %>% 
  filter(production > 0)

green <- "#38bc1c"
yellow <- "#ffe135"

world %>% 
  left_join(df, by = c("name_long" = "area")) %>% 
  ggplot() +
  geom_sf(aes(fill = production)) +
  scale_fill_gradient2(low = "white",
                       mid = green,
                       midpoint = 11e6,
                       high = yellow,
                       na.value = "grey95",
                       name = "Production\nin tonnes",
                       labels = scales::number_format(scale = 1/1e6, suffix = "M")) +
  labs(title = "BANANA PRODUCTION AROUND THE WORLD",
        subtitle = str_wrap("India produced 31.5 million tonnes of bananas in 2020, almost three times as much as the number two: China.",
                            60),
        caption = " Data: FAOSTAT") +
  theme_void() +
  theme(
    text = element_text(family = "font"),
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    plot.caption = element_text(hjust = 0.5),
    legend.position = "bottom"
    )

ggsave(paste0("./2022/15_Food.png"),
       width = 5, height = 6, dpi = 300, bg = "white",
       device = "png")

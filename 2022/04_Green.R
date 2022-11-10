library(cbsodataR)
library(tidyverse)
library(sf)
library(patchwork)

uitslag <- read_csv2("./data/Uitslag_alle_gemeenten_TK20210317.csv") %>%
  mutate(RegioCode = str_replace(RegioCode, "G", "GM")) %>%
  rename(vvd = VVD,
         d66 = D66,
         pvv = 13,
         cda = CDA,
         sp = 15,
         pvda = 16,
         groenlinks = GROENLINKS,
         fvd = 18,
         pvdd = 19,
         cu = 20,
         volt = 21,
         ja21 = 22,
         sgp = 23,
         denk = 24,
         plus50 = 25,
         bbb = 26,
         bij1 = 27)

municipalBoundaries <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2021_gegeneraliseerd&outputFormat=json")

data <-
  municipalBoundaries %>%
  left_join(uitslag, by=c("statcode" = "RegioCode")) %>% 
  mutate(groenlinks= groenlinks / GeldigeStemmen)

light <- "#fefcfe"
green <- "#006E33"

data %>%
  ggplot() +
  geom_sf(aes(fill = groenlinks),
          size = 0.1, colour = "grey80") +
  scale_fill_gradient(
    low = light, high = green, labels = scales::percent_format(),
    name = "% of vote"
    ) +
  labs(title = "VOTE SHARE FOR THE GREENS IN THE NETHERLANDS",
       subtitle = "in the general election of 2021 by municipality",
       caption = "Source: Kiesraad & CBS"
       ) +
  theme_void() +
  theme(
    text = element_text(colour = "#4A5E4C"),
    legend.text = element_text(colour = "#4A5E4C"),
    plot.title.position = "plot",
    plot.title = element_text(size = 15,
                              hjust = 0.5,
                              colour = "#4A5E4C"),
    plot.subtitle = element_text(size = 14,
                                 hjust = 0.5,
                                 colour = "#4A5E4C"),
    plot.caption.position = "plot",
    plot.caption = element_markdown(colour = "#4A5E4C",
                                    hjust = 1)
  )

ggsave("./2022/04_Green.png", height = 6, width = 6, bg = "white")

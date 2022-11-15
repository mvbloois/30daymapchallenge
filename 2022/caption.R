# Credits: https://fosstodon.org/web/@danoehm/109334527061022701

library(ggplot2)
library(glue)
library(showtext)
library(ggtext)

font_add("fa-brands", regular = "c:/users/mvbloois/OneDrive - Brabers/Documenten/fonts/fa-brands-400.ttf")
font_add_google("Karla", "karla")
showtext_auto()

ft <- "karla"
txt <- "grey20"

mastodon <- glue("<span style='font-family:fa-brands; color:{txt}'>&#xf4f6;</span>" )
twitter <- glue("<span style='font-family:fa-brands; color:{txt}'>&#xf099;</span>" )
github <- glue("<span style='font-family:fa-brands; color:{txt}'>&#xf09b;</span>" )
caption <- glue("{mastodon} @martijnvanbloois @fosstodon.org | {twitter} @prancke | {github} mvbloois/30daymapchallenge")

ggplot() +
  labs(caption = caption) +
  theme(
    text = element_text(family = ft, colour = txt, size = 14),
    plot.caption = element_markdown(hjust = 0.5)
  )

library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

transitions <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-28/transitions.csv')
timezone_countries <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-28/timezone_countries.csv')
countries <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-28/countries.csv')

timezone_countries %>% 
  left_join(countries, by = "country_code") %>% 
  left_join(transitions, by = "zone", multiple = "all") %>% 
  filter(place_name %in% c("Finland", "Sweden", "Norway", "Denmark", "Iceland"),
         dst == TRUE) %>% 
  mutate(begin = as.Date(begin),
         end = as.Date(end)) %>% 
  ggplot(aes(x = begin, y = place_name)) +
  geom_segment(aes(xend = end, yend = place_name, colour = place_name), size = 6) + 
  theme_minimal() +
  scale_color_brewer(palette = "Set1") +
  scale_x_date(date_breaks = "10 year", date_labels = "%Y") +
  labs(title = "Daylight Savings in Nordic countries") +
  theme(
    legend.position = "none",
    legend.title = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
    panel.grid.major.x = element_blank(),
    text = element_text(size = 15),
    axis.text.y = element_text(face = "bold"),
    plot.margin = margin(1, 1, 1, 1, "cm")
  )

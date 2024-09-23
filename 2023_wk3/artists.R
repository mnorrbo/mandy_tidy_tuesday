#cdevtools::install_github("hrbrmstr/waffle")

library(dplyr)
library(waffle)
library(wesanderson)

artists = readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-01-17/artists.csv')

artists_subset = artists %>% 
  filter(year > 2000) %>% 
  count(year, artist_gender)

ggplot(artists_subset, aes(fill = artist_gender, values = n)) +
  geom_waffle(
    color = "white",
    size = .25,
    n_rows = 10,
    flip = TRUE,
    na.rm = FALSE
  ) +
  facet_wrap(~year, nrow = 1, strip.position = "bottom") +
  scale_x_discrete() +
  scale_y_continuous(
    labels = function(x)
      x * 10,
    expand = c(0, 0)
  ) +
  scale_fill_manual(
    values = wes_palette("Darjeeling1")
  ) +
  coord_equal() +
  labs(title = "Artists by Gender",
       x = "",
       y = "") +
  theme_minimal(base_family = "URWBookman",
                base_size = 15) +
  theme(
    panel.grid = element_blank(),
    axis.ticks.y = element_line(),
    legend.position = "bottom",
    legend.title = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 30, face = "bold")
  )

afrisenti <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-02-28/afrisenti.csv')
languages <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-02-28/languages.csv')

library(dplyr)
library(ggplot2)
library(ggdark)
library(ggthemes)
library(ggtext)
library(showtext)
font_add_google("Lexend", "lexend")
showtext_auto()


afrisenti %>% 
  left_join(languages, by = "language_iso_code") %>% 
  mutate(sentiment_num = if_else(label == "negative", -1, 1)) %>% 
  group_by(language) %>% 
  summarise(avg_sentiment = mean(sentiment_num)) %>% 
  ggplot(aes(x = avg_sentiment, y = reorder(language, avg_sentiment), colour = avg_sentiment)) +
  geom_point(size = 4, shape = 18) +
  scale_color_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  scale_x_continuous(limits = c(-1, 1)) +
  dark_mode(theme_fivethirtyeight(), verbose = FALSE) +
  theme(legend.position = "none",
        axis.title.x = element_text(),
        plot.margin = margin(1, 1, 1, 1, "cm"),
        plot.title = element_text(size = 18, hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        text = element_text(size = 15, family = "lexend", face = "bold")) +
  labs(y = "",
       x = "\nAverage sentiment",
       title = "Avg. sentiment of tweets in African languages",
       subtitle = "Negative = -1; Positive = 1")

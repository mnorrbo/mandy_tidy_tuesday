eggproduction  <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-04-11/egg-production.csv')
cagefreepercentages <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-04-11/cage-free-percentages.csv')

library("ggplot2")
library("dplyr")
library("scales")

ylim.prim <- c(13500000, 341166000)
ylim.sec <- c(298074240, 8601000000)

b <- diff(ylim.prim)/diff(ylim.sec)
a <- ylim.prim[1] - b*ylim.sec[1]

eggproduction %>% 
  filter(prod_type == "table eggs", prod_process == "all") %>% 
  ggplot(aes(x = observed_month)) +
  geom_line(aes(y = n_hens), colour = "red", linewidth = 1) + 
  geom_line(aes(y = a + n_eggs*b), colour = "blue", linewidth = 0.6) + 
  scale_y_continuous(
    labels = comma,
    # Features of the first axis
    name = "Number of hens\n",
    # Add a second axis and specify its features
    sec.axis = sec_axis(~ (. - a)/b, name = "Number of eggs\n", labels = comma)
  ) +
  theme_minimal() +
  theme(
    axis.title.y = element_text(color = "red", size = 13, face = "bold"),
    axis.title.y.right = element_text(color = "blue", size = 13, face = "bold"),
    axis.title.x = element_text(size = 13, face = "bold"),
    axis.text = element_text(size = 10, face = "bold"),
    plot.title = element_text(size = 25, face = "bold", hjust = 0.5),
    plot.margin = margin(1, 1, 1, 1, "cm")
  ) +
  labs(x = "\nYear",
       title = "Egg Production\n") 

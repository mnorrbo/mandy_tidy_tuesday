london_marathon <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-04-25/london_marathon.csv')

library(dplyr)
library(tidyr)
library(ggplot2)
library(showtext)

font_add_google("Arimo", "arimo")
showtext_auto()

my_palette = c("#f72585","#7209b7","#3a0ca3","#738af2","#4cc9f0")

london_marathon %>% 
  select(Year:Finishers) %>% 
  drop_na() %>% 
  mutate(across(Applicants:Finishers, ~(.x/Applicants) * 100)) %>% 
  pivot_longer(cols = -Year,
               names_to = "Type",
               values_to = "Percentage") %>% 
  mutate(Type = forcats::fct_reorder(Type, -Percentage)) %>% 
  ggplot(aes(x = Year, y = Percentage, colour = Type, fill = Type)) +
  geom_area(position = "identity", alpha = 0.4, size = 0.3) +
  scale_fill_manual(values = my_palette) +
  scale_colour_manual(values = my_palette) +
  scale_y_continuous(labels = scales::label_percent(scale = 1)) +
  labs(title = "London Marathon Applicants") +
  theme_minimal() +
  theme(
    legend.title = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
    panel.grid.major.x = element_blank(),
    text = element_text(size = 15, family = "arimo"),
    axis.text = element_text(face = "bold"),
    plot.margin = margin(1, 1, 1, 1, "cm")
  )

# library(treemap)
# 
# london_marathon %>%
#   summarise(
#     across(
#       Applicants:Finishers,
#       ~sum(.x, na.rm = TRUE)
#     )
#   ) %>%
#   pivot_longer(cols = everything(),
#                names_to = "Type",
#                values_to = "Count") %>%
#   treemap(
#     index = "Type",
#     vSize = "Count",
#     palette = "Reds"
#   )

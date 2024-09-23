cats_uk = readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-01-31/cats_uk.csv')
cats_uk_reference = readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-01-31/cats_uk_reference.csv')


library("ggplot2")
library("dplyr")
library("showtext")
font_add_google("Rubik", "rubik")
showtext_auto()

cats_uk_reference %>%
  count(animal_sex, hunt) %>%
  filter(!is.na(hunt)) %>%
  mutate(
    hunt = if_else(hunt, "Allowed to hunt", "Not allowed to hunt"),
    animal_sex = if_else(animal_sex == "f", "Female", "Male")
  ) %>%
  ggplot(aes(x = animal_sex, y = n)) +
  geom_col(aes(fill = hunt), position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal(base_size = 15) +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 35, face = "bold"),
    panel.grid.major.x = element_blank(),
    text = element_text(family = "rubik"),
    axis.text.x = element_text(face = "bold")
  ) +
  scale_fill_manual(values = c("#648fff", "#dc267f")) +
  labs(title = "\nWhich cats are allowed to hunt?")


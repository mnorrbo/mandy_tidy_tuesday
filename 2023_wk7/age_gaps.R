age_gaps <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-02-14/age_gaps.csv')

# Creepiness rule: “half your age plus seven.”

library("dplyr")
library("ggplot2")
library("showtext")
library("ggtext")
library("glue")
font_add_google("PT Sans", "pt-sans")
showtext_auto()

title = "How many movie age gaps <span style='color: #a8160c;'>fail the creepiness rule</span> i.e. 'half your age plus seven'?<br>"


age_gaps %>%
  mutate(
    meets_rule = ((actor_1_age / 2) + 7) <= actor_2_age,
    gender_group = paste(character_1_gender, character_2_gender, sep = "-"),
    gender_group = case_when(
      character_1_gender == "man" &
        character_2_gender == "woman" ~ "Man is older than woman",
      character_1_gender == "man" &
        character_2_gender == "man" ~ "Man is older than man",
      character_1_gender == "woman" &
        character_2_gender == "man" ~ "Woman is older than man",
      character_1_gender == "woman" &
        character_2_gender == "woman" ~ "Woman is older than woman"
    )
  ) %>%
  group_by(release_year, gender_group) %>%
  slice(1) %>%
  ggplot(aes(x = release_year)) +
  geom_linerange(aes(
    ymin = actor_2_age,
    ymax = actor_1_age,
    colour = meets_rule
  ),
  size = 1) +
  geom_point(aes(y = actor_2_age, colour = meets_rule), size = 2) +
  geom_point(aes(y = actor_1_age, colour = meets_rule), size = 2) +
  facet_wrap( ~ gender_group, strip.position = "bottom") +
  theme_minimal() +
  theme(
    legend.position = "none",
    strip.text = element_text(face = "bold"),
    text = element_text(family = "pt-sans", size = 70),
    axis.title.x = element_markdown(face = "bold"),
    axis.title.y = element_markdown(face = "bold"),
    plot.title = element_markdown(size = 100, hjust = 0.5, face = "bold"),
    plot.margin = margin(1.5, 1.5, 1.5, 1.5, "cm")) +
  labs(title = title,
       x = "<br>Release Year",
       y = "Age of Actors<br>") +
  scale_colour_manual(values = c("#a8160c", "#b3b3b3"))

ggsave("age_gaps.jpg")

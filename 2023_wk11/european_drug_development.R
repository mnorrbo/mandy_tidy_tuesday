drugs <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-14/drugs.csv')

library(dplyr)
library(ggplot2)
library(showtext)
font_add_google("Quicksand", "quicksand")
showtext_auto()

top_withdrawn_companies = drugs %>% 
  count(marketing_authorisation_holder_company_name, authorisation_status) %>% 
  filter(authorisation_status == "withdrawn") %>% 
  arrange(desc(n)) %>% 
  slice(1:5) %>% 
  pull(marketing_authorisation_holder_company_name)

authorisation_by_company = drugs %>% 
  filter(marketing_authorisation_holder_company_name %in% top_withdrawn_companies) %>% 
  count(marketing_authorisation_holder_company_name, authorisation_status) %>% 
  rename("company_name" = "marketing_authorisation_holder_company_name") %>% 
  group_by(company_name) %>% 
  mutate(percent = n / sum(n))

withdrawn_order = authorisation_by_company %>% 
  filter(authorisation_status == "withdrawn") %>% 
  arrange(percent) %>% 
  mutate(company_name = factor(company_name))


authorisation_by_company %>%
  ggplot(aes(
    x = factor(
      company_name,
      levels = withdrawn_order$company_name,
      ordered = TRUE
    ),
    y = n
  )) +
  geom_col(aes(fill = authorisation_status), position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(y = "", x = "Company", title = "Companies with most withdrawn drugs") +
  coord_flip() + 
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
    panel.grid.major.x = element_blank(),
    text = element_text(size = 15, family = "quicksand"),
    axis.text.y = element_text(face = "bold"),
    plot.margin = margin(1, 1, 1, 1, "cm")
  ) +
  scale_fill_manual(breaks = c("withdrawn", "refused", "authorised"), 
                    values = c("#999999", "#f0baaf", "#c6d6bf")) 

# library(tidytext)

# custom_stop_words = c("treatment")
# condition_words = drugs %>% 
#   select(condition_indication, authorisation_status) %>% 
#   unnest_tokens(output = word,
#                 input = condition_indication) %>%
#   count(authorisation_status, word, sort = TRUE) %>% 
#   anti_join(stop_words, by = "word") %>% 
#   filter(!(word %in% custom_stop_words)) %>% 
#   group_by(authorisation_status) %>% 
#   slice_max(n, n = 20)
# 
# 
# count(condition_words, word, sort = TRUE)
# 
# 
# top_withdrawn_drugs = drugs %>% 
#   count(active_substance, authorisation_status) %>% 
#   filter(authorisation_status == "withdrawn") %>% 
#   arrange(desc(n)) %>% 
#   slice(1:5) %>% 
#   pull(active_substance)
# 

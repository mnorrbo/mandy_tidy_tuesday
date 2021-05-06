library(shiny)

library(tidyverse)

netflix_titles <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-04-20/netflix_titles.csv')


type_options <- unique(netflix_titles$type)


# genre selection ---------------------------------------------------------

max_categories <- netflix_titles %>% 
  mutate(comma_count = str_count(listed_in, ",")) %>% 
  summarise(max_comma_count = max(comma_count, na.rm = TRUE)) %>% 
  summarise(max_categories = max_comma_count + 1) %>% 
  pull()

netflix_titles <- netflix_titles %>% 
  separate(listed_in, 
           into = paste("category", 1:max_categories), 
           sep = ",") %>% 
  pivot_longer(
    cols = `category 1`:(paste("category", max_categories)),
    names_to = "category_no",
    values_to = "genre"
  ) %>% 
  mutate(genre = trimws(genre)) %>% 
  drop_na(genre)

genre_options <- unique(netflix_titles$genre)


# table(netflix_titles$type, netflix_titles$genre) # no genres in both movie and tv show -> separate input for both



movie_genre_summary <- netflix_titles %>% 
  group_by(type, genre) %>% 
  summarise(count = n(), .groups = "drop") %>% 
  select(-count)

movie_genre_choices <- movie_genre_summary %>% filter(type == "Movie") %>% select(genre)

tv_genre_choices <- movie_genre_summary %>% filter(type == "TV Show") %>% select(genre)
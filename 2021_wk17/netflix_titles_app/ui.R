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
    mutate(genre = trimws(genre))

genre_options <- unique(netflix_titles$genre)

ui <- fluidPage(
    
    radioButtons(
        "type",
        "Movie or TV show",
        choices = type_options
    ),
    
    selectizeInput(
        "genre", 
        label = "Which genres are you interested in?",
        choices = genre_options,
        multiple = TRUE
    ),
    
    
    DT::dataTableOutput(
        "netflix_table"
    )
    
    
)
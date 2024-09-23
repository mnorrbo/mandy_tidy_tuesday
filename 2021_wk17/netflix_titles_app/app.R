library(shiny)
library(shinyWidgets)
library(tidyverse)

netflix_titles <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-04-20/netflix_titles.csv')
genre_matching <- read_csv("genre_matching.csv")

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
    drop_na(genre) %>% 
    left_join(genre_matching) %>% 
    drop_na(name)

ui <- fluidPage(
    
    awesomeRadio(
        "movie_or_tv",
        "Movie or TV show",
        choices = c(type_options, "I don't mind" = "Both"),
        status = "warning"
    ),
    
    uiOutput("conditional_genre"),
    
    actionButton("find_show", "Find something to watch"),

    textOutput("title_text")
    
)

server <- function(input, output){
    
    output$conditional_genre <- renderUI({
        
        genre_choices <- netflix_titles %>% 
            filter(type == input$movie_or_tv) %>%  # don't filter if "i don't mind' selected
            distinct(name) %>% 
            arrange(name) %>% 
            pull()
        
        selectInput("genre", 
                    label = "Which genres are you interested in?",
                    choices = genre_choices,
                    multiple = TRUE
        )
    })
    
    recommended_title <- eventReactive(input$find_show, {
        
        netflix_titles %>% 
            filter(genre %in% input$genre) %>% 
            slice_sample(n = 1) %>% 
            pull(title)
        
    })
    
    output$title_text <- renderText({
        recommended_title()
    })
}

shinyApp(ui, server)
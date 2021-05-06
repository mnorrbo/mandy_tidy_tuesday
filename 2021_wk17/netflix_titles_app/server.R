server <- function(input, output){
    
    output$conditional_genre <- renderUI({
        
        genre_choices <- netflix_titles %>% 
            filter(type == input$movie_or_tv) # don't filter if "i don't mind' selected
            distinct(label) %>% 
            arrange(label) %>% 
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

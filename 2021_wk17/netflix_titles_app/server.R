server <- function(input, output){
    
    output$conditional_genre <- renderUI({
        
        genre_choices <- netflix_titles %>% 
            filter(type == input$movie_or_tv) %>% 
            distinct(genre) %>% 
            pull()
        
        selectizeInput(
            "genre", 
            label = "Which genres are you interested in?",
            choices = genre_choices,
            multiple = TRUE)
    })
    
    output$netflix_table <- DT::renderDataTable(
        netflix_titles %>% 
            select(title, description, type, genre) %>% 
            filter(genre %in% input$genre)
    )
}

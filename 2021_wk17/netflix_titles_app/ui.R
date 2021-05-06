

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
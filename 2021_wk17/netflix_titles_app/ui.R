

ui <- fluidPage(
    
    radioButtons(
        "movie_or_tv",
        "Movie or TV show",
        choices = type_options
    ),
    
    uiOutput("conditional_genre"),
    
    
    
    
    DT::dataTableOutput(
        "netflix_table"
    )
    
    
)
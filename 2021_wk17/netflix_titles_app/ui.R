

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
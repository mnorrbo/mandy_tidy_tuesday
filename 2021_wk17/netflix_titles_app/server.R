server <- function(input, output){
    
    output$netflix_table <- DT::renderDataTable(
        netflix_titles %>% 
            select(title, description, type, genre) %>% 
            filter(type == input$type) %>%
            filter(genre %in% input$genre) %>% 
            slice_sample(n = nrow(.))
    )
    
    
}

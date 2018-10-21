```{r shiny-viz}
library(DT)

ui <- basicPage(
  h2("The NYC education data"),
  DT::dataTableOutput("education")
)

server <- function(input, output) {
  output$mytable = DT::renderDataTable({
    education
  })
}
  
shinyApp(ui, server)
```
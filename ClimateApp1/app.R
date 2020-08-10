#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(lubridate)

# Define UI for application that draws a plot for different data inputs
ui <- fluidPage(

    sidebarLayout(
        sidebarPanel(
            selectInput('min_year', 'Start Year', choices = 1850:2015, 1850),
            selectInput('max_year', 'End Year', choice = 1850:2015, 2015),
            selectInput('dataset', 'Data Selection', choice = c("Global Average Land Temperature", "Global Average Land and Ocean Temperature")),
            checkboxInput('lin', 'Best Fit Line')
        ),
        
        mainPanel(
            titlePanel('Global Average Temperatures Changing With Time'),
            plotOutput('plot')
        )
        
    ),
    hr(),
    
    print("Berkeley Earth Temperature Data: http://berkeleyearth.org/data/")
)

land.data <- read.csv('Datasets/land_temperature.csv')
land_ocean.data <- read.csv('Datasets/land_ocean_temperature.csv')

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot <- renderPlot({
        if (input$dataset == "Global Average Land Temperature"){
            land <- land.data %>%
                subset((Year >= input$min_year) & (Year <= input$max_year))
        if (input$lin) {
            ggplot(land, aes(x=Year, y=LandAvgTemp)) + geom_point() + geom_line() + geom_smooth(color='blue', method = 'lm') + ylab('Celcius') + ggtitle("Global Average Land Temperature")
        } # End of "if user selects best fit line
        
        else {
            ggplot(land, aes(x=Year, y=LandAvgTemp)) + geom_point() + geom_line() + ylab('Celcius') + ggtitle("Global Average Land Temperature")
        } # end of else
        
        } # end of if user selects the first set of data
        
        else {
            land_ocean<- land_ocean.data %>%
                subset((Year >= input$min_year) & (Year <= input$max_year))
            if (input$lin) {
                ggplot(land_ocean, aes(x=Year, y=LandOceanAvgTemp)) + geom_point() + geom_line() + geom_smooth(color='red', method = 'lm') + ylab('Celcius') + ggtitle("Global Average Land and Ocean Temperature")
            } # End of "if user selects best fit line
            
            else {
                ggplot(land_ocean, aes(x=Year, y=LandOceanAvgTemp)) + geom_point() + geom_line() + ylab('Celcius') + ggtitle("Global Average Land and Ocean Temperature")
            } # end of else
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

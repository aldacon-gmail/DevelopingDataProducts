#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

qa <- levels(diamonds$cut)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Diamomds"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "cut",
                  label = "Cut Quality:",
                  choices = qa,
                  selected = qa[3]),
      sliderInput("carats", "Number of Carats:", 
                   min = 0, max = 2.5, value= 1, step = 0.01),
      sliderInput("price", "Price:", 
                  min = 6000, max = 20000, value= 1, step = 10)
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("distPlot")
    )
  )
))

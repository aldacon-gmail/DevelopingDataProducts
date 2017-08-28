#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlotly({
         set.seed(100)
         d <- diamonds[diamonds$cut==input$cut, ]          
         d <- d[sample(nrow(d), 1000), ]          
         
         mod<-gam(price ~ s(carat, bs="cs"),data=diamonds)
         Y<- predict(mod, data.frame(carat = input$carats))

         p <- ggplot() +
              geom_point(data = d, aes(x = carat, y = price, text = paste("Clarity:", clarity)), size = .5) +
              geom_point(aes(text="Evaluated:", x = input$carats, y = input$price, size=5, color="red", fill = "red")) + 
              geom_smooth(data = d, aes(text = "Predicted", x = carat, y = price, colour = cut, fill = cut), show.legend = FALSE) +
              theme(legend.position = "none")

         ggplotly(p)
         
  })
  
})

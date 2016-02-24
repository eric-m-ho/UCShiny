
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(tidyr)
library(data.table)

UCData <- fread("data/UCData.csv")

#reformat data
UCDatalong <- gather(UCData, Stats, NumberOfStudents, UCBApplicants:UCMEnrollees)

shinyServer(function(input, output) {

  output$title <- renderText({
    input$school
  })
  output$pic <- renderImage({
    
    pict <-switch(input$school,
                  "UC Berkeley" = "UCBlogo.png",
                  "UCLA" = "UCLAlogo.png",
                  "UC San Diego" = "UCSDlogo.png", 
                  "UC Irvine" = "UCIlogo.jpg",
                  "UC Davis"= "UCDlogo.png", 
                  "UC Riverside" = "UCRlogo.png",
                  "UC Santa Barbara" = "UCSBlogo.png",
                  "UC Merced" = "UCMlogo.jpg" 
                  
                  )
    
    list(
      src=paste0("images/", pict),
      height = 200,
      width = 200
      )
  }, deleteFile = FALSE)
  
  output$plot <- renderPlotly({

    
    data1 <- switch(input$school,
                   "UC Berkeley" = UCDatalong[1:63,],
                   "UCLA" = UCDatalong[64:126,],
                   "UC San Diego" = UCDatalong[127:189,], 
                   "UC Irvine" = UCDatalong[190:252,],
                   "UC Davis"=UCDatalong[253:315,], 
                   "UC Riverside" = UCDatalong[316:378,],
                   "UC Santa Barbara" = UCDatalong[379:441,],
                   "UC Merced" = na.omit(UCDatalong[442:504,]))
    
  
    p<-ggplot(data=data1, aes(x=Year, y=NumberOfStudents, colour=factor(Stats, labels = c("Admits", "Applicants", "Enrollees")))) +
      geom_line(size=1.5) +
      geom_point(size = 3, fill = "white")+
      labs(y="Number of Students") + labs(colour = "Legend")
    
    gg <- ggplotly(p)
    gg
    
  })

})


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
                   "UC Berkeley" = UCDatalong[grep("UCB", UCDatalong$Stats),],
                   "UCLA" = UCDatalong[grep("UCLA", UCDatalong$Stats),],
                   "UC San Diego" = UCDatalong[grep("UCSD", UCDatalong$Stats),], 
                   "UC Irvine" = UCDatalong[grep("UCI", UCDatalong$Stats),],
                   "UC Davis"=UCDatalong[grep("UCD", UCDatalong$Stats),], 
                   "UC Riverside" = UCDatalong[grep("UCR", UCDatalong$Stats),],
                   "UC Santa Barbara" = UCDatalong[grep("UCSB", UCDatalong$Stats),],
                   "UC Merced" = na.omit(UCDatalong[grep("UCM", UCDatalong$Stats),]))
    
  
    p<-ggplot(data=data1, aes(x=Year, y=NumberOfStudents, colour=factor(Stats, labels = c("Admits", "Applicants", "Enrollees")))) +
      geom_line(size=1.5) +
      geom_point(size = 3, fill = "white")+
      labs(y="Number of Students") + labs(colour = "Legend")
    
    gg <- ggplotly(p)
    gg
    
  })
  
  output$heatmap <- renderPlotly({
    
    stat <- input$button
    
    UCDatareg<- UCDatalong[grep(pattern = stat, x=UCDatalong$Stats),]
    
    #heatmap
    
    #remove certain part of strings
    UCDatareg$Stats= gsub(pattern = stat, replacement = "",x=UCDatareg$Stats)
    
    q <- ggplot(UCDatareg, aes(Year, Stats)) + geom_tile(aes(fill = NumberOfStudents),
                                                         colour = "white") + scale_fill_gradient(low = "white",
                                                                                                 high = "steelblue")+labs(title = paste(stat, "Heatmap", sep = " "), y = stat, fill = "Number of Students")
    
    heat <- ggplotly(q)
    heat
    
  })

})

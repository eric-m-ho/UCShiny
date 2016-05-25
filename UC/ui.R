
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)

shinyUI(fluidPage(

  # Application title
  titlePanel("UC Data for Mark Keppel High, 1994 - 2015"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h2("UC Schools"),
      helpText("Choose a UC school from the box to see the application,
        acceptance, and enrollment rates for the school. Hover over the
        graphs to see actual numbers. Click on the legend to hide or show
        certain lines."),
      selectInput("school", 
                  label = "Choose a school to be displayed",
                  choices = list("UC Berkeley", "UCLA",
                                 "UC San Diego", "UC Davis",
                                 "UC Riverside", "UC Merced",
                                  "UC Irvine",
                                 "UC Santa Barbara"),
                  selected = "UC Berkeley"),
      em("UC Santa Cruz not included due to lack of data. Data procured
         from the UC Infocenter."),
      br(),
      br(),
      br(),
      helpText("Choose a statistic to be displayed on the heatmap."),
      radioButtons("button",
                   label = "Choose a statistic",
                   choices = list("Applicants", "Admits", "Enrollees")),
      br(),
      br(),
      imageOutput("pic")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h2(textOutput("title")),
      plotlyOutput("plot"),
      br(),
      br(),
      br(),
      plotlyOutput("heatmap")
    )
  )
))

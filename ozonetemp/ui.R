
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(datasets)
data(airquality)

shinyUI(fluidPage(

  # Application title
  titlePanel("Ozone and Temperature in New York"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("span",
                  "Span for Smoother:",
                  min = 0.1,
                  max = 0.9,
                  value = 2/3
      ),
      sliderInput("range",
                  "Select Range:",
                  min = min(airquality$Temp),
                  max = max(airquality$Temp),
                  value = c(min(airquality$Temp), max(airquality$Temp))
      ),
      selectInput("month",
                  "Show Month:",
                  choices = list("May" = 5, "June" = 6, "July" = 7,
                                 "August" = 8, "September" = 9, selected = 7)
     ),
      textInput("title", "Enter Plot Title")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("loessPlot")
    )
  )
))







#sliderInput("month",
#            "Select Month:",
#            min = 5,
#            max = 9,
#            step = 1,
#            value = 7
#),

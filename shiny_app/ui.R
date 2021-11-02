
library(shiny)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(plotly)
#library(semantic.dashboard)


ui <- dashboardPage(skin = 'black', 
  dashboardHeader(title = tags$a(img(src = 'logo.png', height = 100, width = 200),
                                 href='https://ipsdelhi.org.in/')
                    ),
  dashboardSidebar(box(width = 12, background = 'black', height = 100,
                       selectInput('st', label = 'State', selected = 'Odisha',
                                   choices = c('Maharastra', 'Odisha', 'Tripura'), 
                                   multiple = T
                       )),
                   box(width = 12, background = 'black',  height = 100,
                       selectInput('dt', label = 'District', selected = 'Kendrapara',
                                   choices = temp$Dist.,
                                   multiple = T
                       )),
                   br(),
                   box(width = 12, background = 'black', height = 370,
                        textOutput('summary'))
                   ),
  dashboardBody(
    fluidRow(
      valueBoxOutput(outputId = 'tb1', width = 3
      ),
      valueBoxOutput(outputId = 'tb2', width = 3
      ),
      valueBoxOutput(outputId = 'tb3', width = 3
      ),
      valueBoxOutput(outputId = 'tb4', width = 3
      )
    ),
    fluidRow(
      
      box(
        tabsetPanel(
      tabPanel('Line Plot', plotlyOutput('p1')),
      tabPanel('Box Plot', plotlyOutput('p2')), type = 'pills'), 
      width = 8, height = 470
      ),
      
      box(
        leafletOutput('map'), width = 4, height = 470
     )
    )
  )
)

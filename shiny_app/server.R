
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)



server <- function(input, output, sessions){
  
  temp <-     reactive(read.csv('sample.csv'))
  df <-       reactive(temp() %>% 
                   filter(State == input$st, Dist. == input$dt))
  dist <- reactive(unique(df()$Dist.))
  
  #######################################################
  
  output$tb1 <- renderValueBox({
                       valueBox(
                         min(df()$Cases), subtitle = 'Min. Death', color = 'yellow', 
                         icon = icon('head-side-virus')
                         )                   
  })
  output$tb2 <- renderValueBox({
                      valueBox(
                          max(df()$Cases), subtitle = 'Max. Death',  color = 'orange',
                          icon = icon('hospital')
    )                     
  })
  output$tb3 <- renderValueBox({
                      valueBox(
                        round(mean(df()$Cases),0), subtitle = 'Avg.Death', color = 'teal',
                        icon = icon('ambulance')
    )                            
  })
  output$tb4 <- renderValueBox({
                      valueBox(
                        round(sum(df()$Cases),0), subtitle = 'Total Deaths', color = 'blue',
                        icon = icon('procedures') 
                      )                            
  })
  
  output$summary <- renderText({
                        print('Perception is opinion and judgment, based on both cognitive and intuitive understanding.
                              Perception is essential for knowledge, and is a gateway for explorations that are inductive, deductive, as well as intuitive, predictive. The Institute of Perception Studies (IPS) unifies the various aspects of the social, political and cultural, to reveal the underlying disparities that societies across the world have accepted as ‘normal’. ')
  })
  ########################################################
  
  output$p1 <- renderPlotly({
     ggplotly(                        
    df()%>% 
      ggplot(aes(Month, Cases, 
                 col = factor(Year), 
                 group = factor(Year)))+
      geom_point(size = 5, alpha = .3)+
      geom_smooth(se = FALSE)+
      ggthemes::theme_clean()+
      theme(axis.text.x  = element_text(angle = 45),
            axis.title.x = element_blank(),
            legend.position = 'top',
            legend.title = element_blank()
            )
     )
    })
  ########################################################  
  output$p2 <- renderPlotly({
       ggplotly(                   
      df()%>% 
        ggplot(aes(Year, Cases) 
                   )+
       # geom_point(size = 5, alpha = .3)+
        geom_boxplot()+
        geom_text( aes(label = Month, color = Month), size = 3, nudge_x = .05, nudge_y = 0.15) +
        ggthemes::theme_clean()+
        theme(axis.text.x  = element_text(angle = 45),
              axis.title.x = element_blank(),
              legend.position = 'none',
              legend.title = element_blank()
        )
    )
  })
  ###########################################################
  
  output$map <- renderLeaflet({
    df() %>% 
      leaflet() %>% 
      addTiles() %>% 
      addMarkers(lat = temp()$lng, lng = temp()$ltd, clusterOptions = markerClusterOptions(),
                 popup = paste(temp()$State, ':', temp()$Dist.))
    })
}
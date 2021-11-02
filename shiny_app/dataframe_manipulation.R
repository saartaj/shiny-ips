#################################################################
#################################################################
#################################################################

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(leaflet)


#################################################################
#################################################################

df <- read_xlsx('mine-rti.xlsx',sheet = 1,skip = 1)

#################################################################
#################################################################

str(df)

#################################################################
#################################################################
#################################################################

df %>% 
  select(State, Dist., ltd, lng,
         starts_with(c('First_','Second_', 'Third_', 'Fourth_'))) %>%
  pivot_longer(cols = c('First_April':'First_March',
                        'Second_April':'Second_March',
                        'Third_April':'Third_March',
                        'Fourth_April':'Fourth_May'),
              names_to = 'Months_Year',
              values_to = 'Cases') %>% 
  separate(Months_Year, into = c('Year', 'Month')) %>% 
  mutate(Month = factor(Month, levels = c(month.name[4:12], month.name[1:3])),
         Year = ifelse(Year == "First" & Month %in% month.name[4:12], 2018,
                        ifelse(Year == 'First' & Month %in% month.name[1:3], 2019,
                               ifelse(Year == 'Second' & Month %in% month.name[4:12], 2019,
                                      ifelse(Year == 'Second' & Month %in% month.name[1:3], 2020,
                                             ifelse(Year == 'Third' & Month %in% month.name[4:12], 2020,
                                                    2021)
                                             )
                                      )
                               )
                       )
  ) -> dataframe

write.csv(dataframe, 'sample.csv')


###############################################################
###############################################################
###############################################################

temp <- read.csv('sample.csv')

################################################################

temp %>% 
  leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = temp$ltd, lat = temp$lng, 
             clusterOptions = markerClusterOptions(),
             popup = paste(temp$State, ':', temp$Dist.))

#################################################################
######################### PIE   #################################
#################################################################


temp %>% 
  select(State, Dist., Cases) %>% 
  group_by(State, Dist.) %>% 
  summarise(
    TotalDeath = sum(Cases)
  ) %>% 
  ggplot(aes(x = '', y = TotalDeath, fill = State))+
  geom_bar(stat = 'identity', width = 1)+
  coord_polar("y", start = 0)+
  theme_void()+
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) 

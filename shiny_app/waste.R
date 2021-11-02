


library(rvest)
library(dplyr)


url <- "https://hindi.news18.com/shows/aar-paar.html"


page <- url

page %>% 
  read_html() %>% 
  html_nodes('#tab1 p') %>% 
  html_text() -> titles

page %>% 
  read_html() %>% 
  html_nodes('.pagination') %>% 
  html_text() ->


#############################################################
################################################################

url <- "https://www.bing.com/videos/search?&q=aar+paar+news&qft=+filterui:duration-long&FORM=VRFLTR"
























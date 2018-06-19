library(ggplot2)
library(data.table)
library(plotly)
library(forcats)

#Read in data
romanEmperors<-fread('emperors.csv')

#Clean dates
romanEmperors[,birth:=as.Date(birth)]
romanEmperors[,death:=as.Date(death)]
romanEmperors[,reign.start:=as.Date(reign.start)]
romanEmperors[,reign.end:=as.Date(reign.end)]

#Change dates to BCE
#TODO: set birth year to BCE
#romanEmperors[index<5, year(romanEmperors$birth) := -year(romanEmperors$birth)]

#Set factor levels
romanEmperors$name<-factor(romanEmperors$name, levels = romanEmperors$name)
#TODO: reverse factors

#Plot
reignsPlot<-ggplot() +
  geom_segment(data = romanEmperors, aes(x = birth, xend = death, y = name, yend = name), size = 2)+
  geom_segment(data = romanEmperors, aes(x = reign.start, xend = reign.end, y = name, yend = name, color= dynasty), size = 2)+
  xlab('Year') + 
  ylab('Emperor') +
  theme_classic()

plotly::ggplotly(reignsPlot)

#TODO: plots of birthplaces and cause of death/ascension 

#TODO: set up plotly api
#api_create(p, filename = "roman-emperors")
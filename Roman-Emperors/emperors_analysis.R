library(ggplot2)
library(data.table)
library(plotly)
library(forcats)
library(gganimate)

#Read in data
setwd("~/repos/DataViz-R/Roman-Emperors")
romanEmperors<-fread('emperors.csv')

#Clean dates
romanEmperors[,birth:=as.Date(birth)]
romanEmperors[,death:=as.Date(death)]
romanEmperors[,reign.start:=as.Date(reign.start)]
romanEmperors[,reign.end:=as.Date(reign.end)]

#Change dates to BCE
romanEmperors[,birth.year:=year(birth)]
romanEmperors[index<5,birth:=birth - birth.year*365*2 - floor(birth.year/2)]
romanEmperors[index==6,birth:=birth - birth.year*365*2 - floor(birth.year/2)]

#Set factor levels

romanEmperors$name<-factor(romanEmperors$name, levels = romanEmperors$name)
romanEmperors$dynasty<-factor(romanEmperors$dynasty, levels = unique(romanEmperors$dynasty))

#TODO: reverse factors

#Plot

reignsPlot<-ggplot() +
  geom_segment(data = romanEmperors, aes(x = birth, xend = death, y = name, yend = name), size = 2)+
  geom_segment(data = romanEmperors, aes(x = reign.start, xend = reign.end, y = name, yend = name, color= dynasty), size = 2)+
  xlab('Year') + 
  ylab('Emperor') +
  theme_classic()

plotly::ggplotly(reignsPlot)

#gganimate doesn't do cumulative with factors

reignsPlot<-ggplot() +
  geom_segment(data = romanEmperors, aes(x = birth, xend = death, y = name, yend = name, frame = as.numeric(name), cumulative = TRUE), size = 2)+
  geom_segment(data = romanEmperors, aes(x = reign.start, xend = reign.end, y = name, yend = name, color= dynasty,frame = as.numeric(name), cumulative = TRUE), size = 2)+
  xlab('Year') + 
  ylab('Emperor') +
  theme_classic()

gganimate(reignsPlot, "romanemperors.gif",interval = 0.4, ani.width = 1200, ani.height = 800)

#TODO: plots of birthplaces and cause of death/ascension
#TODO: compare cause of death with ascension

#api_create(reignsPlot, filename = "roman-emperors")
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
romanEmperors[is.na(birth), birth:=reign.start]
#Change dates to BCE
romanEmperors[,birth.year:=year(birth)]
romanEmperors[index<5,birth:=birth - birth.year*365*2 - floor(birth.year/2)]
romanEmperors[index==6,birth:=birth - birth.year*365*2 - floor(birth.year/2)]
romanEmperors[index==1,reign.start:=reign.start - year(reign.start)*365*2 - floor(year(reign.start)/2)]

#Simplify Death Causes, 'Natural Causes' == 'Peaceful
romanEmperors[,Power_Transfer:='Violent']
romanEmperors[cause=='Natural Causes' ,Power_Transfer:='Peaceful']

#Set factor levels

romanEmperors$name<-factor(romanEmperors$name, levels = romanEmperors$name)
romanEmperors$dynasty<-factor(romanEmperors$dynasty, levels = unique(romanEmperors$dynasty))

#TODO: reverse factors
beginningYear<-as.Date('0100-01-01')
beginningYear<-beginningYear - year(beginningYear)*365*2

#Plot
#TODO: Manually adjust size
reignsPlotBack<-ggplot() +
  geom_segment(data = romanEmperors, aes(x = beginningYear, xend = birth, y = name, yend = name, color = rise), size = 4) +
  geom_segment(data = romanEmperors, aes(x = death, xend = as.Date('0450-01-01'), y = name, yend = name, color = Power_Transfer), size = 4) +
  geom_segment(data = romanEmperors, aes(x = birth, xend = death, y = name, yend = name), size = 4)+
  geom_segment(data = romanEmperors, aes(x = birth+500, xend = death-500, y = name, yend = name), size = 3.5, color = 'white')+ #hack to get around geom_segment not accepting fill param
  geom_segment(data = romanEmperors, aes(x = reign.start, xend = reign.end, y = name, yend = name), size = 4, color= 'black')+
  xlab('Year') + 
  ylab('Emperor') +
  #scale_color_manual(name = 'rise', values = rise, labels = rise)+
  #scale_color_manual(name = 'end', values = Power_Transfer, labels = Power_Transfer)+
  theme_classic() +
  theme(legend.position = "none")
reignsPlotBack

reignsPlotSide<-ggplot() +
  geom_segment(data = romanEmperors, aes(x = as.Date('0400-01-01'), xend = as.Date('0450-01-01'), y = name, yend = name, color = rise), size = 2)+
  geom_segment(data = romanEmperors, aes(x = as.Date('0450-01-01'), xend = as.Date('0500-01-01'), y = name, yend = name, color = Power_Transfer), size = 2)+
  geom_segment(data = romanEmperors, aes(x = birth, xend = death, y = name, yend = name), size = 2)+
  geom_segment(data = romanEmperors, aes(x = birth+500, xend = death-500, y = name, yend = name), size = 1.5, color = 'white')+ #hack to get around geom_segment not accepting fill param
  geom_segment(data = romanEmperors, aes(x = reign.start, xend = reign.end, y = name, yend = name, color= dynasty), size = 2)+
  xlab('Year') + 
  ylab('Emperor') +
  theme_classic()

#plotly::ggplotly(reignsPlot)

#gganimate doesn't do cumulative with factors

reignsPlot<-ggplot() +
  geom_segment(data = romanEmperors, aes(x = birth, xend = death, y = name, yend = name, frame = as.numeric(name), cumulative = TRUE), size = 2)+
  geom_segment(data = romanEmperors, aes(x = reign.start, xend = reign.end, y = name, yend = name, color= dynasty,frame = as.numeric(name), cumulative = TRUE), size = 2)+
  xlab('Year') + 
  ylab('Emperor') +
  theme_classic()

#gganimate(reignsPlot, "romanemperors.gif",interval = 0.4, ani.width = 1200, ani.height = 800)

#TODO: plots of birthplaces

#api_create(reignsPlot, filename = "roman-emperors")
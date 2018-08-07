library(data.table)
library(ggplot2)
library(openxlsx)
library(plotly)

tsaClaims<-as.data.table(read.xlsx("claims-data-2015-as-of-feb-9-2016.xlsx"))
#Need to compile single dataset
#Bin early data by year

#Look at categorical levels
tsaEDA<-function(){
  unique(tsaClaims$Claim.Type)
  unique(tsaClaims$Claim.Site)
}


#Look at counts by airport and by year
#Separately, look at airline
#Disposition probably independent of airline, but not airport?
#See if any months in particular stand out



tsaClaims[,count:=1]


#Disposition
dispositionByAirport<-ggplot(tsaClaims, aes(x = Airport.Code, y = count, fill = Disposition)) + geom_bar(stat = "identity")
plotly::ggplotly(dispositionByAirport)
#Normalize

#Type

#Site

#Category



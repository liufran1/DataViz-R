library(ggplot2)
library(data.table)

input<-"Chicago_Energy_Benchmarking_-_2015_Data_Reported_in_2016_-_Map.csv"

energyData<-fread(input)

energyPlot<-ggplot(energyData, aes(Longitude,Latitude,color=`Electricity Use (kBtu)`))+geom_point()
energyPlot
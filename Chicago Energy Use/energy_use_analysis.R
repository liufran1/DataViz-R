library(ggplot2)
library(data.table)
library(rgdal)
library(maptools)

# Read the shapefile downloaded from https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Neighborhoods/9wp7-iasj/data
chicago <- rgdal::readOGR(dsn = "Neighborhoods_2012/")
chicago <- sp::spTransform(x = chicago
                           , CRSobj = sp::CRS("+proj=longlat +datum=WGS84"))
chicago <- fortify(chicago) # Organizes data into a neat data frame.

#Data from https://data.cityofchicago.org/Environment-Sustainable-Development/Chicago-Energy-Benchmarking-2015-Data-Reported-in-/g6mw-yynr
energyData<-fread("Chicago_Energy_Benchmarking_-_2015_Data_Reported_in_2016_-_Map.csv")

#Data from https://data.cityofchicago.org/Environment-Sustainable-Development/Green-Roofs-Map/u23m-pa73
#greenRoofs<-fread("Green_Roofs_-_Map.csv")

#Data from https://data.cityofchicago.org/Environment-Sustainable-Development/Map-of-Urban-Farms/uti6-fp3f
#urbanFarms<-fread("Map_of_Urban_Farms.csv")

#Data from https://data.cityofchicago.org/Environment-Sustainable-Development/Farmers-Markets-Map/atzs-u7pv
#farmersMarkets<-fread("Farmers_Markets_-_Map.csv")

#energyPlot<-ggplot(energyData, aes(Longitude,Latitude,color=`Electricity Use (kBtu)`))+geom_point() #+geom_point(data=greenRoofs, aes(LONGITUDE,LATITUDE))
#energyPlot<-ggplot(energyData, aes(Longitude,Latitude,color=`Site EUI (kBtu/sq ft)`))+geom_point()

energyPlot<-ggplot() + 
  geom_path(data = data.table::data.table(chicago), aes(x = long, y = lat, group = group)) +
  geom_density_2d(data = energyData, aes(x = Longitude, y = Latitude, color = `Electricity Use (kBtu)`)) +
  geom_point(data = energyData, aes(x = Longitude, y = Latitude, color = `Electricity Use (kBtu)`), size = 0.1)
energyPlot
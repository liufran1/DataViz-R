library(ggplot2)
library(data.table)
library(plotly)
library(gganimate)

#Read in data
playerData<-fread('../Data/5_players/player_overviews_UNINDEXED.csv',header = FALSE)
playerDataCol<-c(fread('../Data/5_players/player_overviews_column_titles.txt',header = FALSE))
setnames(playerData,names(playerData), unlist(playerDataCol))

rankingData<-fread('../Data/mergedrankings.csv',check.names = TRUE)
#For some reason data.table not reading in the header row
#rankingCol<-c(fread('../Data/4_rankings/rankings_column_titles.txt',header = FALSE))
#setnames(rankingData,names(rankingData),unlist(rankingCol))

#Clean data
playerData<-playerData[height_cm>0]

#Join on player_id
setkey(playerData,player_id)
setkey(rankingData,player_id)

#Only keep players that have been ranked and have data
mergedPlayerRank<-merge(playerData,rankingData,all.x = FALSE, all.y = TRUE)

#Sanity checks on the data using Roger Federer
#federerSanityCheck<-mergedPlayerRank[last_name == 'Federer']
federerSanityCheck_rank<-rankingData[player_id == 'f324']

#Get max rank
maxRank<-mergedPlayerRank[, .SD[which.min(rank_number)], by = player_id]

#Sort by height then rank
maxRank<-maxRank[order(rank_number,height_inches)]

#Filter to look at distribution of world number 1's
heightNumber1<-maxRank[rank_number == 1]
heightNumber1fields<-heightNumber1[,list(player_slug.x,
                                         first_name,
                                         last_name,
                                         height_inches)]
heightNumber1fields[,Name:=paste(first_name,last_name,sep = " ")]
heightNumber1fields<-heightNumber1fields[,list(Name,height_inches)]
heightNumber1fields[,count:=1]
#World number 1's are pretty evenly distributed around 6ft even
#Collapse by height

rankByHeight<-maxRank[,list(highestRank = min(rank_number)), by = height_inches]
rankByHeight<-rankByHeight[height_inches>1]
rankByHeight<-rankByHeight[order(height_inches)]

number1plot<-ggplot(data = heightNumber1fields,aes(x = height_inches, y = count, fill = Name))+geom_bar(stat = "identity")+theme(legend.position="none")
plotly::ggplotly(number1plot)

rankByHeightPlot<-ggplot(data = rankByHeight,aes(x = height_inches, y = 1/highestRank))+geom_bar(stat = "identity")
rankByHeightPlot

#Height of Top 10's over time
top10height<-mergedPlayerRank[rank_number<10]
top10height[,Name:=paste(first_name,last_name,sep = " ")]
top10height[,week_date:=as.Date(week_title,"%Y.%m.%d")]

top10plot<-ggplot(top10height, aes(x = rank_number, y = height_inches, color = Name, frame = week_date))+geom_bar(stat = "identity")

top10height1999<-top10height[week_year==1999]
top10plot1999<-ggplot(top10height1999, aes(x = rank_number, y = height_inches, fill = Name, frame = week_date, cumulative = FALSE))+geom_bar(stat = "identity", position = "identity")+theme(legend.position="none")
gganimate(top10plot1999, "tennisheight1999.gif",interval = 0.1, ani.width = 600, ani.height = 400)

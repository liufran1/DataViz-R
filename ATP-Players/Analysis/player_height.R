library(ggplot2)
library(data.table)

#Read in data
playerData<-fread('../Data/5_players/player_overviews_UNINDEXED.csv',header = FALSE)
playerDataCol<-c(fread('../Data/5_players/player_overviews_column_titles.txt',header = FALSE))
setnames(playerData,names(playerData), unlist(playerDataCol))

rankingData<-fread('../Data/mergedrankings.csv',check.names = TRUE)
#For some reason data.table not reading in the header row
rankingCol<-c(fread('../Data/4_rankings/rankings_column_titles.txt',header = FALSE))
setnames(rankingData,names(rankingData),unlist(rankingCol))

#Clean data
playerData<-playerData[height_cm>0]

#Join on player_id
setkey(playerData,player_id)
setkey(rankingData,player_id)

#Only keep players that have been ranked and have data
mergedPlayerRank<-merge(playerData,rankingData,all.x = FALSE, all.y = TRUE)

#Sanity checks on the data using Roger Federer
#federerSanityCheck<-mergedPlayerRank[last_name == 'Federer']
#federerSanityCheck_rank<-rankingData[player_id == 'f324']

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
#Collapse by height

number1plot<-ggplot()+geom_bar(heightNumber1,aes(x = height_inches, y = player_slug))

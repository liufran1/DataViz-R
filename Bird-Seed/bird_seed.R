library(data.table)
library(ggplot2)
library(dplyr)
library(fastICA)


birdseed<-fread("julydataviz.txt")

#Transform factors to number
seedNames<-colnames(birdseed)[-1:-2]

birdseed[birdseed == "none"]<-0
birdseed[birdseed == "low"]<-1
birdseed[birdseed == "medium"]<-2
birdseed[birdseed == "high"]<-3

birdseedNumeric<-birdseed[,-1:-2]
birdseedNumeric[, names(birdseedNumeric) := lapply(.SD, as.numeric)]

#PCA to visualize in two dimensions

birdPCA <- prcomp(birdseedNumeric, scale. = T)
birdpcaDF<-do.call(rbind, Map(data.frame, FirstFactor=birdPCA$x[,1], SecondFactor=birdPCA$x[,2]))

#kmeans to define clusters
birdCluster <- kmeans(birdpcaDF, 4, nstart = 20)

birdpcaDF$cluster <- as.factor(birdCluster$cluster)
birdpcaDF$bird <- birdseed$bird
ggplot(birdpcaDF, aes(x = FirstFactor, y = SecondFactor, color = birdpcaDF$cluster)) + 
  geom_text(aes(label = bird)) +
  theme(legend.position = "none", 
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())


#Inspired by this post (https://www.reddit.com/r/dataisbeautiful/comments/8vr4rv/grouping_birds_by_their_feeding_preferences_using/)
#to try Independent Component Analysis as an alternative to PCA
birdICA<-fastICA(birdseedNumeric, n.comp = 2)
birdicaDF<-do.call(rbind, Map(data.frame, FirstFactor=birdICA$S[,1], SecondFactor=birdICA$S[,2]))

birdClusterICA <- kmeans(birdicaDF, 3, nstart = 20)

birdicaDF$cluster <- as.factor(birdClusterICA$cluster)
birdicaDF$bird <- birdseed$bird
ggplot(birdicaDF, aes(x = FirstFactor, y = SecondFactor, color = birdicaDF$cluster)) + 
  geom_text(aes(label = bird)) +
  theme(legend.position = "none", 
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

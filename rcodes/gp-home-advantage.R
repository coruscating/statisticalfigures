#--- GP home advantage
#--- check if RUS skaters get higher scores in GP RUS, for instance. 
#--- home: 1 if skater is skating at home in this national GP, 0 else.
#--- Analysis 1:
#--- for each group: predict total score based on home.
#--- Analysis 2: try to predict judges' nationality based on their biases!


rm(list = ls())
library(ggplot2)
setwd("~/gitfolders/statisticalfigures")
data <- read.csv("agg_progs.csv", header = T)
select <- substring(data$comp,1,2) == "gp" & data$comp != "gpf"
data <- data[select,]
data$comp <- substring(data$comp,3,5)
data$nat <- tolower(data$nat)
data$home <- data$comp == data$nat

#recode
data$discp <-  replace(data$discp,data$discp==1,"women")
data$discp <- replace(data$discp,data$discp==0,"men")
data$discp <- as.factor(data$discp)
data$field[data$field == 0] <- "senior"
data$field[data$field == 1] <- "junior"
data$field <- as.factor(data$field)
data$seg[data$seg == 0] <- "SP"
data$seg[data$seg == 1] <- "FP"
data$seg <- as.factor(data$seg)

#--- for each skater: compute a `home-difference' score = mean(tss.home) - mean(tss.nothome). 
data$inter <- interaction(data$seg, data$skname,data$nat, data$home,drop=TRUE)
tss.home <- aggregate(tss ~ inter, data = data,mean)
tpcs.home <- aggregate(tpcs ~ inter+home+nat+seg+discp, data = data,mean)
data.home <- cbind(tpcs.home,tss.home$tss)
names(data.home)[1] <- "skater"
names(data.home)[dim(data.home)[2]] <- "tss"
pdf(file = "plots/gp-home-advantage-all.pdf")
par(mfrow = c(2,1))
boxplot(tss ~ home, data = data.home,main ="tss")
boxplot(tpcs ~ home, data = data.home,main="tpcs")
dev.off()
#some bias but not the case for women.
#better plots
for(seg in c("FP","SP")){
  for(discp in c("men","women")){
      fname = paste("plots/gp-home-advantage",seg,discp,"tss",sep="-")
      fname = paste(fname,"-all.pdf",sep="")
      pdf(file = fname)
      par(mfrow = c(2,1))
      boxplot(tss ~ home, data=data.home[data.home$discp == discp & data.home$seg == seg,], main = paste("tss",discp,seg))
      boxplot(tpcs ~ home, data=data.home[data.home$discp == discp & data.home$seg == seg,], main = paste("tpcs",discp,seg))
      dev.off()
  }
}

  

#plot skaters in the big feds only. Men. 
#each plot: aggregrate over all men with a given nationality

#tss plot
for(seg in c("FP","SP")){
  for(discp in c("men","women")){
      fname = paste("plots/gp-home-advantage",seg,discp,"tss",sep="-")
      fname = paste(fname,".pdf",sep="")
      pdf(file = fname)
      par(mfrow = c(3,2))
      for(nat in levels(factor(data$comp))){
      boxplot(tss ~ home, data=data.home[data.home$nat == nat & data.home$discp == discp & data.home$seg == seg,], main = paste("sknat =", nat))
      }
      dev.off()
  }
}
#tpcs plot
for(seg in c("FP","SP")){
  for(discp in c("men","women")){
      fname = paste("plots/gp-home-advantage",seg,discp,"tpcs",sep="-")
      fname = paste(fname,".pdf",sep="")
      pdf(file = fname)
      par(mfrow = c(3,2))
      for(nat in levels(factor(data$comp))){
      boxplot(tpcs ~ home, data=data.home[data.home$nat == nat & data.home$discp == discp & data.home$seg == seg,], main = paste("sknat =", nat))
      }
      dev.off()
  }
}

pdf(file = "plots/go-home-advantage-men-fp.pdf")
par(mfrow = c(3,4))
for(nat in levels(factor(data$comp))){
boxplot(tss ~ home, data = data.home, subset = data.home$nat == nat & data.home$discp == "men" & data.home$seg == "FP", main = paste("tss men, sknat =", nat))
boxplot(tpcs ~ home+seg, data = data.home, subset = data.home$nat == nat & data.home$discp == "men" & data.home$seg == "FP", main = paste("tpcs men, sknat =", nat))
}
dev.off()

#comment: there is some differences but not statistically significant since data is so few. Probably have to go down to the level of judge nationality. 









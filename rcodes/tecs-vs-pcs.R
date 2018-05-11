#-- analysis: tecs vs pcs
#--- May 11th: added bonus plots for blog
#--- April 18th: first try: use basevalue as a measure of program difficulty, and tecs-basevalue as a measure of "execution quality".
#--- Regression: pcs vs (difficulty) + (quality)
rm(list = ls())
setwd("~/gitfolders/statisticalfigures/")
library(ggplot2)
data <- read.csv("agg_progs.csv", header=T)
data$quality <- data$tes - data$tbv
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

#--- separate into different subsets
data$inter <- interaction(data$field, data$discp,data$seg)


#do a predict with tbv+goe
models <- list()
ar2 <- list()
for(s in levels(data$inter)){
  models[[s]] <- lm(tpcs ~ tbv+quality, data = data, subset = data$inter == s) 
  ar2[[s]] <- summary(models[[s]])$adj.r.squared
}

#do a predict with just tbv
models.bv <- list()
ar2.bv <- list()
for(s in levels(data$inter)){
  models.bv[[s]] <- lm(tpcs ~ tbv, data = data, subset = data$inter == s) 
  ar2.bv[[s]] <- summary(models.bv[[s]])$adj.r.squared
}
#do a predict with just quality
models.q <- list()
ar2.q <- list()
for(s in levels(data$inter)){
  models.q[[s]] <- lm(tpcs ~ quality, data = data, subset = data$inter == s) 
  ar2.q[[s]] <- summary(models.q[[s]])$adj.r.squared
}
#do a predict with just tes
models.t <- list()
ar2.t <- list()
for(s in levels(data$inter)){
  models.t[[s]] <- lm(tpcs ~ tes, data = data, subset = data$inter == s) 
  ar2.t[[s]] <- summary(models.t[[s]])$adj.r.squared
}

#a table of adjusted r-squared for the various models
ar2.raw <- cbind(matrix(unlist(ar2)),matrix(unlist(ar2.bv)),matrix(unlist(ar2.q)), matrix(unlist(ar2.t)))
rownames(ar2.raw) <- rownames(as.matrix(ar2))
colnames(ar2.raw) <- c("tbv.quality","tbv","quality","tes")
ar2.all <- round(ar2.raw,3)*100
#save
ar2.df <- data.frame(ar2.all)
sink(file = "plots/tpcs-vs-tes-adjustedR2.txt")
print(ar2.df)
sink()
#-------- visualize the fit of tpcs vs tes model
#r2 function for loess
loess.r2 <- function(loe.obj){
ss.dist <- sum(scale(loe.obj$y, scale=FALSE)^2)
ss.resid <- sum(resid(loe.obj)^2)    
return(1-ss.resid/ss.dist)
}


models.loe <- list()
par(mfrow = c(1,1))
for(s in levels(data$inter)){
#png(file = paste("plots/tpcs-vs-tes-loess",s,".png",sep=""))
  plot(tpcs ~ tes, data =data, subset = data$inter == s, main = s) 
  abline(coefficients(models.t[[s]]), col = "blue",lwd=2)
  #do a loess fit to check if relationship is linear
  loe <- loess(tpcs ~ tes, data =data, subset = data$inter == s)
  lines(sort(predict(loe)) ~ sort(loe$x), col = "red", lty = 2,lwd =3)  
  models.loe[[s]] <- loess.r2(loe)
#dev.off()
}
loe.df <- as.data.frame(round(unlist(models.loe)*100,3))
names(loe.df) <- c("tes")
print(loe.df)
#conclusion: basically a linear model is jsut as good.







#-- visualize the adjusted R^2:
ar2.df$discp <- c("men","men","women","women","men","men","women","women")
ar2.df$field <- rep(c("junior","senior"),4)
ar2.df$seg <- rep(c("FP","SP"),each = 4)
ar2.df$discp <- as.factor(ar2.df$discp)
ar2.df$field <- as.factor(ar2.df$field)
ar2.df$seg <- as.factor(ar2.df$seg)
ar2.df$type <- row.names(ar2.df)
#scatterplot by group
p <- ggplot(ar2.df, aes(x=tes, y=tbv.quality, colour=discp,shape=field,fill=seg)) + geom_point(size=4) +
geom_text(aes(y=tbv.quality-0.01,label=type))+ scale_shape_manual(values=c(21,24))+ #scale_fill_manual(values=c("gray", "white"))
scale_fill_manual(values=c(NA, "gray"),
guide=guide_legend(override.aes=list(shape=21)))
p + ggtitle("Adjusted R^2, bv.goe vs tes") + geom_abline(aes(intercept=0,slope=1))+ ylab("bv.goe")
ggsave("plots/ar2-tqvstes.png")
#--- 
p <- ggplot(ar2.df, aes(x=tbv, y=tbv.quality, colour=discp,shape=field,fill=seg)) + geom_point(size=4) +
geom_text(aes(y=tbv.quality-0.01,label=type))+ scale_shape_manual(values=c(21,24))+ #scale_fill_manual(values=c("gray", "white"))
scale_fill_manual(values=c(NA, "gray"),
guide=guide_legend(override.aes=list(shape=21)))
p + ggtitle("Adjusted R^2, tbv+quality vs tbv alone")
ggsave("plots/ar2-allvstbv.pdf")
#---- 
p <- ggplot(ar2.df, aes(x=quality, y=tbv.quality, colour=discp,shape=field,fill=seg)) +   geom_point(size=4) +
geom_text(aes(y=tbv.quality-0.01,label=type))+ scale_shape_manual(values=c(21,24))+ #scale_fill_manual(values=c("gray", "white"))
scale_fill_manual(values=c(NA, "gray"),
guide=guide_legend(override.aes=list(shape=21)))
p + ggtitle("Adjusted R^2, tbv+quality vs quality alone")
ggsave("plots/ar2-allvsquality.pdf")
#---------
#--- similar plot for tes. Should compare tes and bvs. 
#---- 
p <- ggplot(ar2.df, aes(x=tbv, y=tes, colour=discp,shape=field,fill=seg)) +   geom_point(size=4) +
geom_text(aes(y=tbv.quality-0.01,label=type))+ scale_shape_manual(values=c(21,24))+ #scale_fill_manual(values=c("gray", "white"))
scale_fill_manual(values=c(NA, "gray"),
guide=guide_legend(override.aes=list(shape=21)))
p + ggtitle("Adjusted R^2, tes vs tbv") + geom_abline(aes(intercept=0,slope=1))
ggsave("plots/ar2-bvvstes.pdf")
ggsave("plots/ar2-bvvstes.png")


#-- Conclusions:
#1/ Total base value (tbv) + quality (total goe minus deductions) predict total PCS well for junior, especially for women (80% to 85% variation). It does less well for senior women, and much less for senior men (TBV alone predict less than 50% for senior men, TBV + quality ~ 65%). 
#2/ Between tbv and quality, tbv accounts for more R^2
#3/ Separating tes into tbv+quality improves R^2 but a fair bit for seniors, but not so much for juniors. 
#-- Meta conclusion
#junior programs: pcs is well-predicted by tes, senior programs less so. 
#between men and women, pcs of women programs are better predicted by tes. 
#tbv alone is a decent predictor of tpcs, much better than goe.  
#====================


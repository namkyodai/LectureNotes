# This program was coded by  Nam Lethanh (lethanh@ibi.baug.ethz.ch)
#Bayesian statistic example - Accident risk analysis
library(LearnBayes) #this is dependency package
p = seq(0.05, 0.95, by = 0.1)
prior = c(1, 5.2, 8, 7.2, 4.6, 2.1, 0.7, 0.1, 0, 0)
prior = prior/sum(prior)
plot(p, prior, type = "h", ylab="Prior Probability")
data = c(11, 16)
post = pdisc(p, prior, data)
#post=round(cbind(p, prior, post),2)
print(post)
library(lattice)
PRIOR=data.frame("prior",p,prior)
POST=data.frame("posterior",p,post)
names(PRIOR)=c("Type","P","Probability")
names(POST)=c("Type","P","Probability")
data=rbind(PRIOR,POST)
print(xyplot(Probability~P|Type,data=data,layout=c(1,2), type="h",lwd=3,col="black"))
#THE END
cat("THE END")
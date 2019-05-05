#This program is coded by Nam Lethanh for use in the class IMP-HS2014
#Purpose: To calculate availability
data <- read.csv("IMP-A-availability.csv",header=TRUE,sep=",") #
attach(data)
T=50
cat("How data looks like?\n")
print(data)
cat("range of observations \n")
range<-max(fre)-min(fre)
print(range)
cat("range of observations - interval \n")

rangetime<-c("9-12","13-16","17-20","21-24","25-28","29-32","33-36","37-40","41-44","45-48")

fre<-c(2,11,24,27,20,15,16,7,2,2)
plot.new()
limy=c(0,1)
barplot(fre, beside = TRUE, axes = FALSE, col = sample(colours(), 5), space = 0.5, names.arg=rangetime,ylim=c(0,30))
axis(2, ylim = limy, col = "black", las = 1)
mtext(expression(paste('Frequency')), side = 2, col = "black", line = 3)
mtext(expression(paste('Range of time')), side = 1, col = "black", line = 3)
box()

library(graphics)
par(new=TRUE)
plot(fre,lwd=2,col="coral4",ylab="",xlab="",ylim=c(0,30),axes=FALSE,lty=1,type="b",pch=10,cex=0.2)
legend("topright", inset = 0.05, col = "coral4", lty = 1, lwd = 2, legend = c("Fit spline"), bg = "aliceblue", cex = 0.8)

#calculate the mean corrective intervention duration
MCID<-sum((data$time)*data$fre)/sum(data$fre)
cat("mean corrective intervention duration \n")
print(MCID)
#calculate the mean of sample
VarX<-(sum(data$fre*(data$time-MCID)^2)/sum(data$fre))^(0.5)
cat("value of standard deviation of sample \n")
print(VarX)

#calculate the geometric mean

lognormalmean<-log(MCID)-0.5*(log(1+VarX^2/(MCID)^2))
cat("value of mean of the lognormal distribution \n")
print(lognormalmean)
cat("value of the geometric mean \n")
geomean<-exp(lognormalmean)
print(geomean)

#calculate the time corresponding to 90% of cummulative distribution
cat("standard deviation of the lognormal \n")
Varx<-log(1+(VarX/MCID)^2)
print(Varx)

#define errors function
erf1=function(x) 2 * pnorm(x * sqrt(2)) - 1

library(pracma)

PDF<- matrix(double(1),nrow=T,ncol=1) # p.d.f
CDF1<-matrix(double(1),nrow=T,ncol=1) #c.d.f
CDF<-matrix(double(1),nrow=T,ncol=1) #c.d.f

x<-matrix(double(1),nrow=T,ncol=1) #c.d.f

pi=3.141592920353982300888888888888888888
for (t in 1:T){
  PDF[t]<-(1/(t*Varx*sqrt(2*pi)))*exp(-((log(t)-lognormalmean)/(2*Varx))^2)
  CDF1[t]<-0.5*(1+erf1((log(t)-lognormalmean)/(Varx*sqrt(2))))
  CDF[t]<-0.5*erfc(-(log(t)-lognormalmean)/(Varx*sqrt(2)))
}
print(cbind(CDF1,CDF))

plot.new()
limy=c(0,1)
limx=c(0,T)
plot(CDF1,lwd=3,col="red",ylab="",xlab="",xlim=limx,ylim=limy,axes=FALSE,lty=1,type="b",pch=12,cex=0.8)
axis(2,c(seq(0,1,by=0.1)),c(seq(0,1,by=0.1)))
axis(1,c(seq(0,T,by=1)),c(seq(0,T,by=1)))
mtext(expression(paste('Probability')),side=2,col="black",line=3)
mtext(expression(paste('Units of time')),side=1,col="black",line=3)
grid(10, 10, col = "lightgray", lty = "dotted",lwd = par("lwd"), equilogs = TRUE)
box()

par(new=TRUE)
plot(CDF,lwd=3,col="blue",ylab="",xlab="",xlim=limx,ylim=limy,axes=FALSE,lty=1,type="b",pch=12,cex=0.8)

segments(0, 0.9, 27, 0.9, col= 'black',lty=2,lwd=2)

segments(27, 0, 27, 0.9, col= 'black',lty=2,lwd=2)





#Set working directory where data has been locally downloaded and unzipped
setwd("C:\Users\Florent\Desktop\MOOC\Explo_Data_Analysis\exdata-data-household_power_consumption")

#Estimate RAM with a 1000 lines sample and check that there is enough memory
size<-object.size(read.table("household_power_consumption.txt", nrows=1000, sep=";"))
nlines<-2075259
totalSize<-size*nlines/1000
print(totalSize, units="Gb")

#totalSize is 0.4Gb. Memory is way larger, so read the data
library(data.table)
table<-read.table("household_power_consumption.txt", sep=";", stringsAsFactors=FALSE, header=TRUE)

#Reformat the dates and set the limit dates of interest
table$Date<-as.Date(table$Date, format="%d/%m/%Y")
minDate<-as.Date("01-02-2007", format="%d-%m-%Y")
maxDate<-as.Date("02-02-2007", format="%d-%m-%Y")

#Reduce table to the part of interest and convert Global Active Data to numeric
library(dplyr)
tableDf<-tbl_df(table)
reducedDf<-filter(tableDf, tableDf$Date>=minDate, tableDf$Date<=maxDate)
reducedDf$Global_active_power<-as.numeric(reducedDf$Global_active_power)

#Preparing x axis labels
nobs<-length(reducedDf$Date)
ticks<-c(1,nobs/2,nobs)
labelVector<-c("Thu","Fri","Sat")

#Preparing legend labels
legend <- names(reducedDf[7:9])

#Create Plot4 and print it with 480px width and height in png file
png(filename = "plot4.png", width = 480, height = 480, units = "px")
  par(mfrow = c(2,2))
  
  plot(reducedDf$Global_active_power,
       type="l",
       xlab="",
       ylab="Global Active Power",
       col="black",
       xaxt = "n")
  axis(1,
       at=ticks,
       labels = labelVector)
  
  plot(reducedDf$Voltage,
       type="l",
       xlab="datetime",
       ylab="Voltage",
       col="black",
       xaxt = "n")
  axis(1,
       at=ticks,
       labels = labelVector)
  
  plot(reducedDf$Sub_metering_1,
       type="l",
       xlab="",
       ylab="Energy sub metering",
       col="black",
       xaxt = "n")
  lines(reducedDf$Sub_metering_2,
        type = "l",
        col = "red")
  lines(reducedDf$Sub_metering_3,
        type = "l",
        col = "blue")
  axis(1,
       at=ticks,
       labels = labelVector)
  legend(x="topright",
         legend,
         lty=1,
         col = c("black","red","blue"),
         box.lty=0,
         bg = "transparent")

  plot(reducedDf$Global_reactive_power,
       type="l",
       xlab="datetime",
       ylab="Global_reactive_power",
       col="black",
       xaxt = "n")
  axis(1,
       at=ticks,
       labels = labelVector)

dev.off()
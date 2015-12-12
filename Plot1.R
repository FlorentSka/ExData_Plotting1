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

#Create Plot1 and print it with 480px width and height in png file
png(filename = "plot1.png", width = 480, height = 480, units = "px")
  hist(reducedDf$Global_active_power,
       ylim=c(0,1200),
       xlab="Global Active Power (kilowatts)",
       col="red",
       main="Global Active Power")
dev.off()
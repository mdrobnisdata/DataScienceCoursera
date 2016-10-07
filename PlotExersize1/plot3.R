## get data
File <- "./data/exDatahhPowerConsum/household_power_consumption.txt"
alldata <- read.table(File, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
## get the subset of data needed for this project
data2days <- alldata[alldata$Date %in% c("1/2/2007","2/2/2007") ,]
## convert data type to date time
dtdate <- strptime(paste(data2days$Date, data2days$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
## convert data type to numeric
ActivePower2Days <- as.numeric(data2days$Global_active_power)
Meter1 <- as.numeric(data2days$Sub_metering_1)
Meter2 <- as.numeric(data2days$Sub_metering_2)
Meter3 <- as.numeric(data2days$Sub_metering_3)
## open graphic device
png("plot3.png", width=480, height=480)
## create plot
plot(dtdate, Meter1, type="l", ylab="Energy Submetering", xlab="")
## Add lines
lines(dtdate, Meter2, type="l", col="red")
lines(dtdate, Meter3, type="l", col="blue")
## add legend
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))
## Close graphic device
dev.off()
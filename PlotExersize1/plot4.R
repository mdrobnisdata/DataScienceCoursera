## get data
File <- "./data/exDatahhPowerConsum/household_power_consumption.txt"
alldata <- read.table(File, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
## get the subset of data needed for this project
data2days <- alldata[alldata$Date %in% c("1/2/2007","2/2/2007") ,]
## convert data type to date time
dtdate <- strptime(paste(data2days$Date, data2days$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
## convert data type to numeric
ActivePower2Days <- as.numeric(data2days$Global_active_power)
ReactivePower2Days <- as.numeric(data2days$Global_reactive_power)
voltage <- as.numeric(data2days$Voltage)
Meter1 <- as.numeric(data2days$Sub_metering_1)
Meter2 <- as.numeric(data2days$Sub_metering_2)
Meter3 <- as.numeric(data2days$Sub_metering_3)
## open graphic device
png("plot4.png", width=480, height=480)
## 2 rows 2 columns
par(mfrow = c(2, 2)) 
## create plot
plot(dtdate, ActivePower2Days, type="l", xlab="", ylab="Global Active Power", cex=0.2)
plot(dtdate, voltage, type="l", xlab="datetime", ylab="Voltage")
plot(dtdate, Meter1, type="l", ylab="Energy Submetering", xlab="")
plot(dtdate, ReactivePower2Days, type="l", xlab="datetime", ylab="Global_reactive_power")
## Add lines
lines(dtdate, Meter2, type="l", col="red")
lines(dtdate, Meter3, type="l", col="blue")
## add Legend
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="o")
## Close graphic device
dev.off()

## get data
File <- "./data/exDatahhPowerConsum/household_power_consumption.txt"
alldata <- read.table(File, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
## get the subset of data needed for this project
data2days <- alldata[alldata$Date %in% c("1/2/2007","2/2/2007") ,]
## convert data type to numeric
ActivePower2Days <- as.numeric(data2days$Global_active_power)
## open graphic device
png("plot1.png", width=480, height=480)
## create plot
hist(ActivePower2Days, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
## Close graphic device
dev.off()
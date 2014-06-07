# download and unzip source data 
if(!file.exists("source_data")) dir.create("source_data")
source_data.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
archive.name <- ".\\source_data\\edhpc.zip"
download.file(source_data.url, archive.name)
unzip(archive.name)

# transform / subset
fname <- "household_power_consumption.txt"
## read file, treat '?' as NA's
ds <- read.table(fname, sep=";",header=TRUE, colClasses=c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), na.strings='?')
## add datetime column 
ds$DateTime <- strptime(paste(ds$Date, ds$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
## subset two first days of Feb 2007
dsFeb <- ds[ds$DateTime >= as.POSIXct("2007-02-01 00:00:00") & ds$DateTime < as.POSIXct("2007-02-03 00:00:00"),]

# plot
## create png device
png(file = "plot3.png", width=480, height=480, bg = "transparent")
## emptry plot 
plot(x=as.POSIXct(dsFeb$DateTime), y=dsFeb$Sub_metering_1, type="n", xlab='', ylab='Energy sub metering')
## add three lines 
lines(x=as.POSIXct(dsFeb$DateTime), y=dsFeb$Sub_metering_1, col="black")
lines(x=as.POSIXct(dsFeb$DateTime), y=dsFeb$Sub_metering_2, col="red")
lines(x=as.POSIXct(dsFeb$DateTime), y=dsFeb$Sub_metering_3, col="blue")
## add legend 
legend("topright", legend=c('Sub_Metering_1', 'Sub_Metering_2', 'Sub_Metering_3'), col=c('black', 'red', 'blue'), lty=1, xjust=1)

# cleanup
dev.off()
## remove file 
file.remove(fname)
## remvoe archive 
file.remove(archive.name)
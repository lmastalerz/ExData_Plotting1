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
png(file = "plot2.png", width=480, height=480, bg = "transparent")
## empty plot
plot(x=as.POSIXct(dsFeb$DateTime), y=dsFeb$Global_active_power, type="n", xlab='', ylab='Global Active Power (kilowatts)')
## add line
lines(x=as.POSIXct(dsFeb$DateTime), y=dsFeb$Global_active_power)

# cleanup
dev.off()
## remove file 
file.remove(fname)
## remvoe archive 
file.remove(archive.name)
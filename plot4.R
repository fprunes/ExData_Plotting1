library(dplyr)

v_fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

v_zipfile <- "exdata_data_household_power_consumption.zip"
v_datafile <- "household_power_consumption.txt"
if (!file.exists(v_zipfile)) {
        download.file(v_fileurl, destfile = v_zipfile, method = "curl")
} else {print("Ya descargado")}


if (!file.exists(v_datafile)) {
        unzip(v_zipfile)
}
v_colnames <- c("cdate","ctime","Global_active_power","Global_reactive_power",
                "Voltage","Global_intensity","Sub_metering_1",
                "Sub_metering_2","Sub_metering_3")
v_colClasses <- c("character","character","numeric","numeric","numeric",
                  "numeric","numeric","numeric","numeric")
data <- read.table(v_datafile, header = TRUE, sep = ";", col.names = v_colnames,
                 colClasses = v_colClasses, comment.char = "",
                 na.strings = "?")
#data <- read.table(v_datafile)
data2 <- mutate(data, Date = as.Date(cdate,format="%d/%m/%Y"), 
                datetime = strptime(paste(cdate,ctime),"%d/%m/%Y %H:%M:%S"))
rm("data")

vini_date <- as.Date("2007-02-01")
vend_date <- as.Date("2007-02-02")
datafil <- filter(data2, Date >= vini_date & Date <= vend_date )
rm("data2")

datasel <- select(datafil,Date, datetime, Global_active_power,
                  Global_reactive_power,Voltage,
                  Global_intensity,Sub_metering_1,
                  Sub_metering_2,Sub_metering_3)
rm("datafil")

# ensure that the names of the days are in English
Sys.setlocale(category = "LC_ALL", locale = "english")

# configure 4 plots
par(mfrow=c(2,2))

# first plot - row 1 , col 1
plot(datasel$datetime,datasel$Global_active_power, col = "black", type = "l",
     xlab = "",
     ylab = "Global Active Power")

# second plot - row 1 , col 2
plot(datasel$datetime,datasel$Voltage, col = "black", type = "l",
     xlab = "datetime",
     ylab = "Voltage")

# third plot - row 2 , col 1
plot(datasel$datetime,datasel$Sub_metering_1, col = "black", type = "l",
     xlab = "",
     ylab = "Energy sub metering")
lines(datasel$datetime,datasel$Sub_metering_2, col = "red", type = "l")
lines(datasel$datetime,datasel$Sub_metering_3, col = "blue", type = "l")
legend("topright",lty = 1, col= c("black","red","blue"), box.lty = 0,
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# fourth plot - row 2 , col 2
plot(datasel$datetime,datasel$Global_reactive_power, col = "black", type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")

dev.copy(png, file = "plot4.png", width = 480, height = 480, units = "px")
dev.off()


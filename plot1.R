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

hist(datasel$Global_active_power, col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (Kilowatts)",
     ylab = "Frequency")

dev.copy(png, file = "plot1.png", width = 480, height = 480, units = "px")
dev.off()


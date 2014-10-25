library(plyr)
library(dplyr)
library(ggplot2)

if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

summary <- NEI %>%     
    filter(fips == "24510") %>%
    filter(type == "ON-ROAD") %>%
    group_by(year) %>% 
    summarize(total = sum(Emissions))

png(filename = "plot5.png")

print(qplot(year, total, data = summary, geom = c("point","smooth"), xlab = "Year", ylab = "PM2.5", main = "Total PM2.5 From Motor Vehicles In Baltimore City, Maryland"))

dev.off()
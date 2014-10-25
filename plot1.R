library(plyr)
library(dplyr)

if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

NEI <- readRDS("data/summarySCC_PM25.rds")

png(filename = "plot1.png")

with(
    NEI %>% 
        group_by(year) %>% 
        summarize(total = sum(Emissions)),        
    plot(year, total, type = "l", xlab = "Year", ylab = "PM2.5", main = "Total PM2.5 Emissions In The US (All Sources)")
)

dev.off()
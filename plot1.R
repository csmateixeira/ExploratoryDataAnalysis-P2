library(plyr)
library(dplyr)
library(reshape2)

if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

NEI <- readRDS("data/summarySCC_PM25.rds")
#SCC <- readRDS("data/Source_Classification_Code.rds")

png(filename = "plot1.png", bg = "transparent")

with(
    NEI %>% 
        group_by(year) %>% 
        summarize(total = sum(Emissions)),        
    plot(year, total, type = "l", xlab = "Year", ylab = "Total PM2.5 (All Sources)")
)

dev.off()
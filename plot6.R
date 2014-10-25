library(plyr)
library(dplyr)
library(lattice)

if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

summary <- NEI %>%     
    filter(fips == "24510" | fips == "06037") %>%
    filter(type == "ON-ROAD") %>%
    transform(fips = factor(fips, labels = c("Los Angeles", "Baltimore City"))) %>%
    group_by(year, fips) %>% 
    summarize(emissions = sum(Emissions))

png(filename = "plot6.png")

print(xyplot(emissions ~ year | fips, data = summary, panel = function(x, y, ...){
    panel.xyplot(x, y, ...)
    panel.lmline(x, y, col = 2)
}))

dev.off()
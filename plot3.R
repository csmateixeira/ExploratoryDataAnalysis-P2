library(plyr)
library(dplyr)
library(ggplot2)

if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

NEI <- readRDS("data/summarySCC_PM25.rds")

summary <- NEI %>% 
    filter(fips == "24510") %>%
    group_by(year, type = factor(type)) %>% 
    summarize(total = sum(Emissions))

png(filename = "plot3.png", width = 1000)

print(qplot(year, total, data = summary, facets = .~type, geom = c("point","smooth"), xlab = "Year", ylab = "PM2.5", main = "Total PM2.5 In Baltimore City, Maryland (Per Source)"))

dev.off()
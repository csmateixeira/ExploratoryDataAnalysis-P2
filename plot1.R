library(plyr)
library(dplyr)

## only if needed: download and extract the data into a "data/" directory in the current working dir
if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

## Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

NEI <- readRDS("data/summarySCC_PM25.rds")

## Summarizing the data:
# - Group NEI by year since what we care about is the year and the emissions for each year
# - Calculate the total emissions for each year and put them into a "total" column
# - Transforming the total dimension to Millions of Tons instead of Tons makes for a more readable graphic and displays the same information
Summary <-
    NEI %>% 
        group_by(year) %>% 
            summarize(total = sum(Emissions)/1000000)

ylab <- expression("Total " * PM[2.5] * " (Millions of Tons)")
main <- expression(PM[2.5] * " Emissions In The US (All Sources)")

png(filename = "plot1.png")

## Plotting a point-and-line graph to ilustrate the decrease year-by-year
with(
    Summary,        
    plot(year, total, type = "b", xlab = "Year", ylab = ylab, main = main)
)

dev.off()
library(plyr)
library(dplyr)

## only if needed: download and extract the data into a "data/" directory in the current working dir
if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

## Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

NEI <- readRDS("data/summarySCC_PM25.rds")

## Summarizing the data:
# - Filter NEI to only show data for Baltimore City only (fips == 24510)
# - Group NEI by year since what we care about is the year and the emissions for each year
# - Calculate the total emissions for each year and put them into a "total" column
# - Transforming the total dimension to Thousands of Tons instead of Tons makes for a more readable graphic and displays the same information
Summary <- 
    NEI %>% 
        filter(fips == "24510") %>%
            group_by(year) %>% 
                summarize(total = sum(Emissions)/1000)

ylab <- expression("Total " * PM[2.5] * " (Thousands of Tons)")
main <- expression(PM[2.5] * " Emissions In Baltimore City, Maryland (All Sources)")

png(filename = "plot2.png")

## Plotting a point-and-line graph to ilustrate the decrease year-by-year
with(
    Summary,        
    plot(year, total, type = "b", xlab = "Year", ylab = ylab, main = main)
)

dev.off()
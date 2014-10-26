library(plyr)
library(dplyr)
library(ggplot2)

## only if needed: download and extract the data into a "data/" directory in the current working dir
if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

## Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

NEI <- readRDS("data/summarySCC_PM25.rds")

## Summarizing the data:
# - Filter NEI to only show data for Baltimore City only (fips == 24510)
# - Group NEI by year and type since we want the data summarized according to both of these variables
# - Transform the type into a factor so we can visualize the changes for each of the type variables
# - Calculate the total emissions for each year and type and put them into a "total" column. Using the total emissions here to compare sources on a yearly basis.
# - Transforming the total dimension to Thousands of Tons instead of Tons makes for a more readable graphic and displays the same information
Summary <- NEI %>% 
    filter(fips == "24510") %>%
    group_by(year, type = factor(type)) %>% 
    summarize(total = sum(Emissions)/1000)

ylab <- expression("Total " * PM[2.5] * " (Thousands of Tons)")
main <- expression(PM[2.5] * " Emissions In Baltimore City, Maryland (Per Source)")

png(filename = "plot3.png", width = 1000)

## Plotting a graph with a facet for each type so the changes per type can be easily vizualized side-by-side and compared with each other
print(qplot(year, total, data = Summary, facets = .~type, geom = c("point","smooth"), xlab = "Year", ylab = ylab, main = main))

dev.off()
library(plyr)
library(dplyr)
library(ggplot2)

## only if needed: download and extract the data into a "data/" directory in the current working dir
if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

## Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

NEI <- readRDS("data/summarySCC_PM25.rds")

## Summarizing the data:
# - Filter NEI to only show data for Baltimore City and Los Angeles County (fips == "24510" | fips == "06037")
# - We only care about motor vehicle sources - I chose to consider a motor vehicle anything which has a type of ON-ROAD. 
#       Definitions of what constitutes a motor vehicle vary and I found that doing this simplified a lot of the process.
# - Transform the fips into a factor so we can visualize the changes for each of the location variables 
# - Group NEI by year and fips since what we care about is the emissions for each year and fips combination
# - Calculate the total emissions for each year and fips and put them into a "total" column. Using the total emissions here to compare locations on a yearly basis.
# - Transforming the total dimension to Thousands of Tons instead of Tons makes for a more readable graphic and displays the same information
Summary <- NEI %>%     
    filter((fips == "24510" | fips == "06037") & type == "ON-ROAD") %>%
    transform(fips = factor(fips, labels = c("Los Angeles", "Baltimore City"))) %>%
    group_by(year, fips) %>%
    summarize(total = sum(Emissions)/1000)

ylab <- expression("Total " * PM[2.5] * " (Thousands of Tons)")
main <- expression(PM[2.5] * " Emissions In Baltimore City vs Los Angeles County From Motor Vehicle Sources")

png(filename = "plot6.png", width = 1000)

## Plotting a graph which points are colored based on Fips - this way we can tell each location apart
## The LM smooth helps to see how much the total emissions value changed in each location over the same years
print(
    ggplot(
        Summary,
        aes(year, total)
    )
    + geom_point(
        aes(color = fips)
    )
    + geom_smooth(
        method = "lm",
        aes(color = fips)
    )
    + labs (
        y = ylab,
        x = "Year",
        title = main
    )
)
    
dev.off()
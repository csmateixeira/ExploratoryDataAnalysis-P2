library(plyr)
library(dplyr)
library(ggplot2)

## only if needed: download and extract the data into a "data/" directory in the current working dir
if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

## Question 5
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

NEI <- readRDS("data/summarySCC_PM25.rds")

## Summarizing the data:
# - We only care about motor vehicle sources - I chose to consider a motor vehicle anything which has a type of ON-ROAD. 
#       Definitions of what constitutes a motor vehicle vary and I found that doing this simplified a lot of the process.
# - Filter NEI to only show data for Baltimore City (fips == 24510)
# - Group NEI by year since we want the data summarized according to year
Summary <- NEI %>%     
    filter(fips == "24510" & type == "ON-ROAD") %>%
    group_by(year)

ylab <- expression(PM[2.5] * " (Log10 Scale)")
main <- expression(PM[2.5] * " Emissions In Baltimore City From Motor Vehicle Sources")

png(filename = "plot5.png")

## Using boxplots to show the overall change year-on-year: this way all changes are considered - changes in median, percentiles, outliers, etc.
## Using the Log10 scale since it still reflects the same proportions in the change while making the graph (more) readable
print(
     ggplot(
         Summary, 
         aes(x = factor(year), y = log10(Emissions))
    ) 
    + geom_boxplot() 
    + labs (
        y = ylab,
        x = "Year",
        title = main
    )
)

dev.off()
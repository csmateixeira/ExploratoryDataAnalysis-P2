library(plyr)
library(dplyr)
library(ggplot2)

## only if needed: download and extract the data into a "data/" directory in the current working dir
if(!file.exists("data/NEI_data.zip")){
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/NEI_data.zip", method = "curl")
    unzip("data/NEI_data.zip", exdir = "data")
}

## Question 4
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Summarizing the data:
# - We only care about coal combustion related sourcesso filtering SCC based on EI.Sector that contains "Coal"
# - Merged NEI with SCC - only relevant "Coal" related rows are merged
# - Group NEI by year since we want the data summarized according to year
Summary <- 
    NEI %>% 
        merge(SCC[grepl("Coal", SCC$EI.Sector, perl = TRUE), c("SCC", "EI.Sector")], by = "SCC") %>%
            group_by(year)

ylab <- expression(PM[2.5] * " (Log10 Scale)")
main <- expression(PM[2.5] * " Emissions In The US From Coal combustion-Related Sources")

png(filename = "plot4.png")

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
## plot3.R
##
## We download and read in data from the EPA's National Emissions Inventory (NEI) database.
## We create a plot to investigate changes in emissions from 4 types (point, nonpoint, onroad, nonroad)
## of PM2.5 sources in the Baltimore City from 1999 to 2008.

## If necessary, create directory, download and unzip dataset.

if(!file.exists("./data")){dir.create("./data")}

if(!file.exists("./data/exdata-data-NEI_data.zip")){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl,destfile="./data/exdata-data-NEI_data.zip",method="curl")
}

if(!file.exists("./data/exdata-data-NEI_data")){
        unzip("./data/exdata-data-NEI_data.zip",exdir="./data")
}

## Read in dataset from file.

NEI <- readRDS("./data/summarySCC_PM25.rds")

## Subset for Baltimore City

baltNEI <- NEI[NEI$fips == 24510,]

## Build dataset.

baltimoreemissionsbytype<-aggregate(baltNEI[,4], by=list(baltNEI$year, baltNEI$type), FUN=sum)
colnames(baltimoreemissionsbytype) <- c("year", "type", "totalemissions")

library(ggplot2)

## Construct plot.

p <- ggplot(data=baltimoreemissionsbytype, aes(x=year, y=totalemissions, colour=type)) + 
        geom_line()+ 
        xlab("Years") +
        ylab("Total Emissions") +
        ggtitle("Total Emissions by Type in Baltimore City 1999 - 2008")

## Save plot to working directory.

ggsave(filename = "plot3.png", plot=p, width=7, height=5, dpi=100)

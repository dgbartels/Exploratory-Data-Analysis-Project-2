## plot6.R
##
## We download and read in data from the EPA's National Emissions Inventory (NEI) database.
## We create a plot to investigate changes in emissions from motor vehicle sources in 
## Baltimore City from 1999 to 2008.

## If necessary, create directory, download and unzip dataset.

if(!file.exists("./data")){dir.create("./data")}

if(!file.exists("./data/exdata-data-NEI_data.zip")){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl,destfile="./data/exdata-data-NEI_data.zip",method="curl")
}

if(!file.exists("./data/exdata-data-NEI_data")){
        unzip("./data/exdata-data-NEI_data.zip",exdir="./data")
}


## Read in datasets from files.

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

## Subset NEI based on data in SSC where Data.Category = "Onroad".
## This excludes aircraft, water craft, trains, farm equipment, etc.
## We are looking at motor vehicles driven on roads

SCConroad <- SCC[SCC$Data.Category == "Onroad",]
keepscc <- SCConroad$SCC
NEIonroad <- NEI[NEI$SCC %in% keepscc,]

## Subset for Baltimore City

baltNEIonroad <- NEIonroad[NEIonroad$fips == "24510",]

## Build dataset.

baltimoreemissions<-aggregate(baltNEIonroad [,4], by=list(baltNEIonroad $year), FUN=sum)
baltimoreemissions$city <- c("Baltimore")
colnames(baltimoreemissions) <- c("year", "totalemissions", "city")

## Subset for Los Angeles

laNEIonroad <- NEIonroad[NEIonroad$fips == "06037",]

## Build dataset.

losangelesemissions<-aggregate(laNEIonroad [,4], by=list(laNEIonroad $year), FUN=sum)
losangelesemissions$city <- c("Los Angeles")
colnames(losangelesemissions) <- c("year", "totalemissions", "city")

## Merge datasets

dat <- rbind(baltimoreemissions,losangelesemissions)

library(ggplot2)

## Construct plot.

p <- ggplot(data=dat, aes(x=year, y=totalemissions, colour=city)) + 
        geom_line()+ 
        xlab("Years") +
        ylab("Total Motor Vehicle Emissions") +
        ggtitle("Motor Vehicle PM2.5 Emissions Baltimore vs. Los Angeles 1999 - 2008")

## Save plot to working directory.

ggsave(filename = "plot6.png", plot=p, width=8, height=5, dpi=100)

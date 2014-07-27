## plot2.R
##
## We download and read in data from the EPA's National Emissions Inventory (NEI) database.
## We create a plot to investigate whether total emissions from PM2.5 sources decreased in the 
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

## Read in dataset from file.

NEI <- readRDS("./data/summarySCC_PM25.rds")

## Subset for Baltimore City

baltNEI <- NEI[NEI$fips == 24510,]

## Build dataset.

baltimoreemissions<-aggregate(baltNEI[,4], by=list(baltNEI$year), FUN=sum)
colnames(baltimoreemissions) <- c("year", "totalemissions")

## Open graphics device.

png(file = "plot2.png")

## Construct plot.

plot(baltimoreemissions$year, baltimoreemissions$totalemissions,
     main = "Total Baltimore City PM25 Emissions Between 1999 & 2008",
     xlab = "Year",
     ylab = "Total Baltimore City Emissions"
)

regressionline <- lm(baltimoreemissions$totalemissions~baltimoreemissions$year)
abline(regressionline, col= "red")

## Close graphics device.

dev.off()
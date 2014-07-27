## plot1.R
##
## We download and read in data from the EPA's National Emissions Inventory (NEI) database.
## We create a plot to investigate whether total emissions from PM2.5 decreased in the 
## United States from 1999 to 2008.

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


## Build dataset.

ustotemissions<-aggregate(NEI[,4], by=list(NEI$year), FUN=sum)
colnames(ustotemissions) <- c("year", "ustotalemissions")

## Open graphics device.

png(file = "plot1.png")

## Construct plot.

plot(ustotemissions$year, ustotemissions$ustotalemissions,
     main = "Total US PM25 Emissions Between 1999 & 2008",
     xlab = "Year",
     ylab = "Total US Emissions"
)

regressionline <- lm(ustotemissions$ustotalemissions~ustotemissions$year)
abline(regressionline, col= "red")

## Close graphics device.

dev.off()
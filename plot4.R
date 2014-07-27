## plot4.R
##
## We download and read in data from the EPA's National Emissions Inventory (NEI) database.
## We create a plot to investigate changes in total emissions from coal related sources in the 
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


## Read in datasets from files.

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

## Subset NEI for coal sources based on data in SSC

keepcoal <- grep("Coal", SCC$SCC.Level.Three, fixed = TRUE)
scccoal <- SCC[keepcoal,]
keepscc <- scccoal$SCC
NEIcoal <- NEI[NEI$SCC %in% keepscc,]

## Build dataset.

ustotemissions<-aggregate(NEIcoal[,4], by=list(NEIcoal$year), FUN=sum)
colnames(ustotemissions) <- c("year", "ustotalemissions")

## Plot
## geom_smooth() produces many warnings here, but the resulting plot still works.
## This should be acceptable in exploratory data analysis

library(ggplot2)

p <- ggplot(data=ustotemissions, aes(x=year, y=ustotalemissions)) + 
        geom_point() +
        geom_smooth() +
        xlab("Years") +
        ylab("Total Emissions") +
        ggtitle("Total US Emissions of Coal Related Sources 1999 - 2008")

## Save plot to working directory.

ggsave(filename = "plot4.png", plot=p, width=7, height=5, dpi=100)

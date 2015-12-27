url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
filename <- 'dataset.zip'
f <- file.path(getwd(), filename)

if (!file.exists(filename)) {
  download.file(url, filename)
}

if (!file.exists('summarySCC_PM25.rds') && !file.exists('Source_Classification_Code.rds')) { 
  unzip(filename)
}

library(ggplot2)

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS('Source_Classification_Code.rds')

NEI_bal <- NEI[NEI$fips == '24510', ]

SCC_veh <- grepl('vehicle', SCC$SCC.Level.Two, ignore.case = TRUE)

NEI_bal_veh <- merge(NEI_bal, SCC[SCC_veh, ], by = 'SCC')

ttl_bal_veh <- aggregate(Emissions ~ year, NEI_bal_veh, sum)

png('plot5.PNG', width = 640, height = 480, units = 'px', bg = 'transparent')
g <- ggplot(ttl_bal_veh, mapping = aes(factor(year), Emissions))
g <- g + geom_bar(stat = 'identity') +
  xlab('Year') +
  ylab(expression('PM'[2.5]*' Emissions in Tons')) +
  ggtitle(expression('Total Emissions of PM'[2.5]*' from motor vehicles in Baltimore City per year'))
print(g)
dev.off()
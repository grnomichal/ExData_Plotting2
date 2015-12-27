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

NEI_balt <- NEI[NEI$fips == '24510', ]

ttl_per_type_balt <- aggregate(Emissions ~ year + type, NEI_balt, sum)

png('plot3.PNG', width = 640, height = 480, units = 'px', bg = 'transparent')
g <- ggplot(ttl_per_type_balt, mapping = aes(year, Emissions, col = type))
g <- g + geom_line() +
  xlab('Year') +
  ylab(expression('PM'[2.5]*' Emissions')) +
  ggtitle(expression('Total Emission of PM'[2.5]*' in Baltimore City by type per year'))
print(g)
dev.off()
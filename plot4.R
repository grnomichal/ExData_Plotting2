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

SCC_coal <- grepl('coal', SCC$Short.Name, ignore.case = TRUE)

NEI_coal <- merge(NEI, SCC[SCC_coal, ], by = 'SCC')

ttl_coal <- aggregate(Emissions ~ year, NEI_coal, sum)

png('plot4.PNG', width = 640, height = 480, units = 'px', bg = 'transparent')
g <- ggplot(ttl_coal, mapping = aes(factor(year), Emissions/(10^5)))
g <- g + geom_bar(stat = 'identity') +
  xlab('Year') +
  ylab(expression('PM'[2.5]*' Emissions in 10^5 Tons')) +
  ggtitle(expression('Total Emissions of PM'[2.5]*' from Coal Combustion per year'))
print(g)
dev.off()
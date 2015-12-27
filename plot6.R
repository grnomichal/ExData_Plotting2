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

NEI_bal_la <- NEI[NEI$fips == '24510' | NEI$fips == '06037', ]

SCC_veh <- grepl('vehicle', SCC$SCC.Level.Two, ignore.case = TRUE)

NEI_bal_la_veh <- merge(NEI_bal_la, SCC[SCC_veh, ], by = 'SCC')

ttl_bal_la_veh <- aggregate(Emissions ~ year + fips, NEI_bal_la_veh, sum)

ttl_bal_la_veh$region[ttl_bal_la_veh$fips == '06037'] <- 'Los Angeles'
ttl_bal_la_veh$region[ttl_bal_la_veh$fips == '24510'] <- 'Baltimore City'

png('plot6.PNG', width = 640, height = 480, units = 'px', bg = 'transparent')
g <- ggplot(ttl_bal_la_veh, mapping = aes(factor(year), Emissions))
g <- g + geom_bar(stat = 'identity') +
  facet_grid(. ~ region) +
  xlab('Year') +
  ylab(expression('PM'[2.5]*' Emissions in Tons')) +
  ggtitle(expression('Total Emissions of PM'[2.5]*' from motor vehicles in Baltimore City vs Los Angeles per year'))
print(g)
dev.off()
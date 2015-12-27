url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
filename <- 'dataset.zip'
f <- file.path(getwd(), filename)

if (!file.exists(filename)) {
  download.file(url, filename)
}

if (!file.exists('summarySCC_PM25.rds') && !file.exists('Source_Classification_Code.rds')) { 
  unzip(filename)
}

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS('Source_Classification_Code.rds')

NEI_balt <- NEI[NEI$fips == '24510', ]

total_balt <- aggregate(Emissions ~ year, NEI_balt, sum)

png('plot2.PNG', width = 640, height = 480, units = 'px', bg = 'transparent')
barplot(
  height = total_balt$Emissions, 
  names.arg = total_balt$year,
  xlab = 'Year',
  ylab = expression('PM'[2.5]*' Emissions'),
  main = expression('Total Emission of PM'[2.5]*' in Baltimore City per year')
)
dev.off()
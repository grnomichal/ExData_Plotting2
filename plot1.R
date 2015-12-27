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

total <- aggregate(Emissions ~ year, NEI, sum)

png('plot1.PNG', width = 640, height = 480, units = 'px', bg = 'transparent')
barplot(
  height = total$Emissions/(10^6), 
  names.arg = total$year,
  xlab = 'Year',
  ylab = expression('PM'[2.5]*' Emissions (in millions of Tons)'),
  main = expression('Total Emission of PM'[2.5]*' per year')
  )
dev.off()
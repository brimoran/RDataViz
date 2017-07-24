setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # set working directory

#Load required libraries (installing them if necessary)
for (package in c('ggplot2', 'ggthemes', 'scales')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

data <- read.csv("financial_results.csv",header=TRUE) # Read csv file. 

options(scipen=999) # supress scientific notation

colPalette <- c(tableau_color_pal('colorblind10')(10))

# prepare to print to pdf
pdf(file="Line_chart_colour_blind.pdf", width = 8, height = 4.5) # 16 by 9 ratio, change filename accordingly

# Line plot

ggplot(data, aes(x = Year, y = Result, group = Variable, color = Variable)) +
  geom_line() +
  geom_point(size = 1.1) + 
  ggtitle("Operating Results") +
  labs(x = "Year", 
       y = "£k") +
  theme_hc() +
  scale_y_continuous(labels = comma) +
  scale_colour_manual(values = colPalette) + 
  annotate("rect", xmin = 2017, xmax = 2018, ymin = 0, ymax = 80000,
           alpha = .1) + # adding shaded area
  annotate("text", label="Forecast", color = "gray", x=2017.5, y=77000, size=3) # adding annotation

# output pdf
dev.off()
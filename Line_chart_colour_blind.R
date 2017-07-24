setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # set working directory

#Load required libraries (installing them if necessary)
for (package in c('ggplot2', 'ggthemes', 'scales')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

# Creating simulated data, replace with:
# data <- read.csv("YOURFILENAME.csv",header=TRUE)
data <- data.frame(Variable=c("a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c"), 
                   Result=c(50, 43, 22, 54, 37, 29, 57, 39, 32, 54, 33, 38), 
                   Year=c(2016, 2016, 2016, 2017, 2017, 2017, 2018, 2018, 2018, 2019, 2019, 2019))

options(scipen=999) # supress scientific notation

colPalette <- c(tableau_color_pal('colorblind10')(10))

# prepare to print to pdf
pdf(file="Line_chart_colour_blind.pdf", width = 8, height = 4.5) # 16 by 9 ratio, change filename accordingly

# Line plot

ggplot(data, aes(x = Year, y = Result, group = Variable, color = Variable)) +
  geom_line() +
  geom_point(size = 1.1) + 
  ggtitle("Your Title") +
  labs(x = "Year", 
       y = "Units") +
  theme_hc() +
  scale_y_continuous(labels = comma) +
  scale_colour_manual(values = colPalette)

# output pdf
dev.off()
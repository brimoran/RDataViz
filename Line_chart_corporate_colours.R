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

colPalette <- colorRampPalette(c("#8E0A26", "white")) # set up colour function based on corporate colour, in this case #8E0A26

# prepare to print to pdf
pdf(file="Line_chart_corporate_colours.pdf", width = 8, height = 4.5) # 16 by 9 ratio, change filename accordingly

# Line plot

ggplot(data, aes(x = Year, y = Result, group = Variable, color = Variable)) +
  geom_line() +
  geom_point(size = 1.1) + 
  ggtitle("Your Title") +
  labs(x = "Year", 
       y = "Units") +
  theme_hc() +
  scale_y_continuous(labels = comma) +
  scale_x_continuous(breaks=c(2016, 2017, 2018, 2019)) + # Not neccessary in this case, but provided to show how you can decide how x axis is displayed
  scale_colour_manual(values = colPalette(1+nlevels(data$Variable)))  # 1+nlevels(data$Variable) provides enough values in colfunc to show all lines clearly, one more than you might think as the final colour is white
  
# output pdf
dev.off()

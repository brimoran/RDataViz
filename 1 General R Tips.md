# R tips

This section is not intended to provide a comprehensive primer for R.  Rather it is a collection of the useful tips that the data viz examples use.  It is also an opportunity for me to explain why they are used.

## Working directory

For simplicity, I would suggest keeping your R scripts and data sources in the same directory.  If you do, the following code can be used right at the start of your scripts to set your working directory to the location of the R script.  This will help ensure that your work is easily portable for others:

```r
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # set working directory
```

*Note*: this requires R studio to be used and the rstudioapi package to have been previously installed.  The rstudioapi package is installed just like any other package in R:

```r
install.packages("rstudioapi") # Assumes that repository has already been set in R Studio
```

## Installing and loading libraries

A nice solution to help ensure that your code can be shared easily with colleagues is to install necessary packages on the fly if they are not already present in another R installation.  The following for-loop example achieves this:

```r
#Load required libraries (installing them if necessary)
for (package in c('ggplot2', 'ggthemes','ggmap', 'scales')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}
```
Example from code published by Daniel Sparing at https://stackoverflow.com/questions/5595512/what-is-the-difference-between-require-and-library

In this case ggplot2, ggthemes, ggmap and scales will be loaded, or installed and then loaded if not already present.

## Loading data

The examples given here either provide dummy data within the R script or use R's in-built datasets to ensure reproducibility.

Each example loads a dataset as data frame  "data".  For example:

```r
data <- women # load in-built dataset
```

To replace this with your own csv data, comment out or delete the existing line that creates the data frame "data" and use the following code instead:

```r
# data <- women # load in-built dataset - commented out
data <- read.csv("YOURFILENAME.csv",header=TRUE, sep = ',') # Read csv file, change YOURFILENAME
```

## Checking the structure of data

In R Studio you can easily view data through the GUI.  Sometimes it is more convenient to use the following command instead however:

```r
str(data) # Check structure of data
```

## Cleaning imported data

Files sourced in a corporate environment are often messy.

By defining and using a clean function we can make sure that numeric csv data is cleansed of common extraneous characters (commas, pound signs etc.) that would cause problems with analysis in R:

```r
clean <- function(ttt){
as.numeric( gsub('[^a-zA-Z0-9.]', '', ttt))
}
```

To apply to the entire data frame of variables (be careful in using this as it will bork any variables in your data frame which you need to be non-numeric):

```r
data[] <- sapply(data, clean) # Assumes that the clean function has already been created
```
Example from code published at: http://earlh.com/blog/2009/06/29/cleaning-data-in-r-csv-files/


To apply to a single variable:

```r
data$YOURVARIABLENAME <- sapply(data$YOURVARIABLENAME, clean) # Assumes that the clean function has already been created, change text in capitals
```

To apply to specific variables in the data frame:

```r
data[,c("YOURVARIABLENAME","YOUROTHERVARIABLENAME")] <- sapply(data, clean) # Assumes that the clean function has already been created, change text in capitals
```

#### Removing incomplete data

Removing rows of incomplete data is not necessary for plotting but is required for some analysis you may need to undertake prior to plotting.  Only use if incomplete data is causing problems in your workflow:

```r
data <- na.omit(data) # deletes rows with missing data
```

## Working with dates

You need to be explicit about date formats in R.  Use as.Date to tell R to change a field in your data frame to a particular date format. 

### DMY

e.g. date in format dd/mm/yyyy:

```r
data$YOURVARIABLENAME <- as.Date(data$YOURVARIABLENAME, "%d/%m/%Y") # transform a field name to dd/mm/yyyy, change text in capitals
```

### YMD

e.g. date in format [yyyy-mm-dd](https://xkcd.com/1179/):

```r
data$YOURVARIABLENAME <- as.Date(data$YOURVARIABLENAME, "%Y-%m-%d") # transform a field name to yyyy-mm-dd, change text in capitals
```

Note the substitution of '/' with '-' in this example.

## Suppressing scientific notation

We are producing data viz for business here and so it is useful to suppress scientific notation, i.e. we would rather show the number one million as 1,000,000 than as 1e6.  To get part of the way towards this use the following code in your R script prior to plotting:

```r
options(scipen=999) # supress scientific notation
```

With scientific notation suppressed, the number one million will be shown by R as 1000000.  We will need to use a further line of code in our plots to also show comma separators.

## Subsetting data

Subsetting can be easily achieved in R by using the "subset" command.  Use normal R logical operators for equivalent to "==", not equivalent to "!=", and "&", or "|" [etc](http://www.statmethods.net/management/operators.html).

```r
subsetdata <- subset(data, YOURVARIABLENAME != "YOURCHARACTERVALUE" &  YOUROTHERVARIABLENAME > YOURNUMERICVALUE) # subset the data
```
Alternatively, and [prefered](https://stackoverflow.com/questions/9860090/why-is-better-than-subset):

```r
subsetdata <- data[data$YOURVARIABLENAME != "YOURCHARACTERVALUE" & data$YOUROTHERVARIABLENAME > YOURNUMERICVALUE, ]
```

### Exporting plots


#### Plot dimensions

One of the big advantages of using R to produce dataviz is the consistency that can be achieved from one plot to the next.

I would suggest using two (and only two) aspect ratios depending on the plot and the context in which it will be viewed:

* 16:9
* 4:3

A 16:9 aspect ratio tends to work well for plots to be included within a document and also for presentations.

A 4:3 aspect ratio works well for plots that will be viewed full-screen on a tablet which is common in a corporate setting.


#### Plotting to file

As a vector format, the PDF file format offers high fidelity output.  PDF files can prove difficult to print however if they use excessive transparencies.  For example, a plot of a map that shows thousands of individual, overlaid semi-transparent points will probably fail to flatten when printing.  In such cases a better choice would be to use a raster format such as a PNG file.

##### Output to PDF

Surround your plot with the following code:

```r
pdf(file="FILENAME.pdf", width = 8, height = 4.5) # Prepare to output PDF with 16 by 9 ratio, change text in capitals

# YOUR PLOT HERE

dev.off() # output file
```

##### Output to PNG

Surround your plot with the following code:

```r
png(file="FILENAME.png", width = 1600, height = 900) # 16 by 9 ratio, change text in capitals

# YOUR PLOT HERE

dev.off() # output file
```

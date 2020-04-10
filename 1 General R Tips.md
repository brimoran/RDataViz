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

## Transposing data

```r
library(tibble)
library(dplyr)

data <- data %>%
  t() %>%
  as.data.frame(stringsAsFactors = F) %>%
  rownames_to_column("value") %>%
  `colnames<-`(.[1,]) %>%
  .[-1,] %>%
  `rownames<-`(NULL)
```

## Stacking data

```r
data <- stack(data) # transform separate columns into a single vector with two columns (values and ind)
```

## Cleaning imported data

Files sourced in a corporate environment are often messy.

By defining and using a clean function we can make sure that numeric csv data is cleansed of common extraneous characters (commas, pound signs etc.) that would cause problems with analysis in R:

```r
clean <- function(ttt){
as.numeric( gsub('[^a-zA-Z0-9.]', '', ttt))
}
```

Example from code published at: http://earlh.com/blog/2009/06/29/cleaning-data-in-r-csv-files/

To apply to the entire data frame of variables (be careful in using this as it will bork any variables in your data frame which you need to be non-numeric):

```r
data[] <- sapply(data, clean) # Assumes that the clean function has already been created
```

To apply to a single variable:

```r
data$YOURVARIABLENAME <- sapply(data$YOURVARIABLENAME, clean) # Assumes that the clean function has already been created, change text in capitals
```

To apply to specific variables in the data frame:

```r
data[,c("YOURVARIABLENAME","YOUROTHERVARIABLENAME")] <- sapply(data, clean) # Assumes that the clean function has already been created, change text in capitals
```

#### Trim white space

```r
data < - trimws(data, which = c("both")) # trims white space either side of string
```

#### Using gsub

An alternative approach is to use gsub which replaces all matches of a particular character (string).  For example to remove pound signs:

```r
data$YOURVARIABLENAME <- gsub("£", "", paste(data$YOURVARIABLENAME)) # remove £
```

#### Creating a dummy variable

```r
data$DUMMYVARIABLE <- as.numeric(data$COLUMNNAME == "CONDITION")
```

#### Changing a single value

```r
data[ROWNUMBER, COLUMNNUMBER] = NEWVALUE # changing a single value - row then column
```

#### Limiting data to a few columns of interest

```r
data <- data[,c("YOURVARIABLENAME","YOUROTHERVARIABLENAME")]
```

Alternatively, specify the columns you want to remove:

```r
data <- data[, -c(0:2)] # Drop first two columns
```

#### Removing incomplete data

Removing rows of incomplete data is not necessary for plotting but is required for some analysis you may need to undertake prior to plotting.  Only use if incomplete data is causing problems in your workflow:

```r
data <- na.omit(data) # deletes rows with missing data
```

Alternatively, to remove rows where a particular variable is missing data:

```r
data <- data[!(is.na(data$YOURVARIABLENAME) | data$YOURVARIABLENAME==""), ]
```

Similarly:

```r
data <- data[!(is.na(data$YOURVARIABLENAME) | data$YOURVARIABLENAME=="-"), ] # strip out records that include NA fields or  just a "-"
```

Or to remove entire blank rows:

```r
data <- data[!apply(is.na(data) | data == "", 1, all),] # remove rows wth NAs or blanks
```

To remove rows which only contain NA values:

```r
data <- data[rowSums(is.na(data)) != ncol(data),] # Drop rows which are entirely NA
```

Likewise for columns:

```r
data <- data[,colSums(is.na(data))<nrow(data)] # Drop columns which are entirely NA
```

Alternatively, remove columns that contain any NA values:

```r
data <- data[ , colSums(is.na(data)) == 0] # remove columns which contain any NAs
```

Or to remove columns that only contain zeros:

```r
data <- data[, colSums(data != 0) > 0] # remove columns which sum to zero
```

## Tidy column headings (variable names)

```r
names(data)[names(data) == 'YOUROLDNAME'] <- 'YOURNEWNAME'
```

## Change levels/labels in factor

```r
levels(data$Measure)# check existing levels
data$Measure <- revalue(data$YOURVARIABLENAME, c("old name"="new name")) # rename factor level requires library("plyr")
```

## Converting data recognised as a character format into a numeric format

If your 'numeric' data is messy and contains characters such as '£'s, ','s or 'm's for example, R will recognise this in a character format.  Chances are you will need it to be recognised as numeric, so after you clean it you will need to convert it to numeric data:

```r
data$YOURVARIABLENAME <- as.numeric(as.character(data$YOURVARIABLENAME))
```

Change the entire dataframe to numeric:

```r
data[] <- lapply(data, as.numeric) # make entire dataframe numeric
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

### Order by Date

```r
data <- data[order(as.Date(data$YOURDATEVARIABLE,format="%Y/%m/%d")),,drop=FALSE] # order by date
```

### Aggregate by Date

```r
byday <- aggregate(cbind(YOURVARIABLENAME)~Date, data=data,FUN=sum)
library(lubridate)
byday$Month <- floor_date(byday$YOURVARIABLENAME, "month") # Get dates into month bins (requires lubridate)
```

### Create a Dataframe of Dates

```r
library(lubridate)
dates <- as.data.frame(seq(ymd('2014-04-01'),ymd('2017-10-01'),by='month')) # create a data frame of months
colnames(dates) <- c("Month") # correct column name
```

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

Note, if after subsetting your levels of factors has (should have) reduced, correct stored levels in R with:

```r
subsetdata$YOURVARIABLENAME <- factor(subsetdata$YOURVARIABLENAME)
```

### [Grep](https://en.wikipedia.org/wiki/Grep)

You can use Grep to subset on particular patterns of characters in your data.  This example subsets cases so those where "this text" is present in ```data$YOURVARIABLENAME``` are not included:

```r
subsetdata <- data[!grepl("this text",data$YOURVARIABLENAME),] # remove case with "this text" in YOURVARIABLE NAME
```

### Duplicates

You can subset to remove duplicates in your data frame as follows:

```r
subsetdata <- data[!duplicated(data$YOURVARIABLENAME), ]
```

## Horizontal [Joins](https://en.wikipedia.org/wiki/Join_(SQL))

Example:

```r
merged <- merge(x = LEFTDATAFRAME, y = RIGHTDATAFRAME, by.x = "LEFTCOMMONVARIABLE", by.y='RIGHTCOMMONVARIABLE', all.x=TRUE) # left outer join
```
Nice summary from [Data Science Made Simple](http://www.datasciencemadesimple.com/join-in-r-merge-in-r/):

- **Natural join**: To keep only rows that match from the data frames, specify the argument all=FALSE.
- **Full outer join**:To keep all rows from both data frames, specify all=TRUE.
- **Left outer join**:To include all the rows of your data frame x and only those from y that match, specify all.x=TRUE.
- **Right outer join**:To include all the rows of your data frame y and only those from x that match, specify all.y=TRUE.

## Vertical joins (stacking) data frames

To stack one dataframe on top of another, make sure that the number of columns and names are identical and then:

```r
merged <- rbind(DATAFRAME1, DATAFRAME2)
```

## Exporting to csv

```write.csv(data, file = "FILENAME.csv")```

## Exporting plots


### Plot dimensions

One of the big advantages of using R to produce dataviz is the consistency that can be achieved from one plot to the next.

I would suggest using two (and only two) aspect ratios depending on the plot and the context in which it will be viewed:

* 16:9
* 4:3

A 16:9 aspect ratio tends to work well for plots to be included within a document and also for presentations.

A 4:3 aspect ratio works well for plots that will be viewed full-screen on a tablet which is common in a corporate setting.


### Plotting to file

As a vector format, the PDF file format offers high fidelity output.  PDF files can prove difficult to print however if they use excessive transparencies.  For example, a plot of a map that shows thousands of individual, overlaid semi-transparent points will probably fail to flatten when printing.  In such cases a better choice would be to use a raster format such as a PNG file.

#### Output to PDF

Surround your plot with the following code:

```r
pdf(file="FILENAME.pdf", width = 8, height = 4.5) # Prepare to output PDF with 16 by 9 ratio, change text in capitals

# YOUR PLOT HERE

dev.off() # output file
```

#### Output to PNG

Surround your plot with the following code:

```r
png(file="FILENAME.png", width = 1600, height = 900) # 16 by 9 ratio, change text in capitals

# YOUR PLOT HERE

dev.off() # output file
```

#### Output to HTML

The plotly library works well with ggplots.

Assuming you have created a ggplot named 'plot' and have already installed the plotly and htmlwidgets libraries, the following code will output your plot as an interactive HTML page:

```r
library(plotly)
plot <- ggplotly(plot)
library(htmlwidgets)
saveWidget(plot, file="plot.html")
```

# R tips

This section is not intended to provide a comprehensive primer for R.  Rather it is a collection of the useful tips that the data viz examples use.  It is also an opportunity for me to explain why they are used.

## Working directory

For small projects, I would suggest keeping your R scripts and data sources in the same directory.  If you do, the following code can be used right at the start of your scripts to set your working directory to the location of the R script.  This will help ensure that your work is easily portable for others:

```r
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # set working directory
```

*Note*: this requires R studio to be used and the rstudioapi package to have been previously installed.  The rstudioapi package is installed just like any other package in R:

```r
install.packages("rstudioapi") # Assumes that repository has already been set in R Studio
```
An alternative that is more portable between say a Linux server and Mac:

```r
# Set working directory to script location
library(this.path)
setwd(this.path::this.dir())
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
## Create an empty data frame

```r
TOTALhourly <- data.frame(Number=integer(),
                 Position=character(),
                 Hourly.Rate=numeric(),
                 Gender=factor(),
                 X=logical(),
                 X=logical(),
                 X=logical(),
                 X=logical(),
                 X=logical(),
                 X=logical(),
                 X=logical(),
                 X=logical(),
                 X=logical(),
                 X=logical(),
                 stringsAsFactors=FALSE)
```

## Loading lots of csvs at once

This loads each csv in a folder into R as a data frame.
```r
# Read files names in csv folder
filenames <- list.files(path="./data/csv/", pattern="*.*csv")# assumes files are in the specified folder

# Create list of dataframe names without the ".csv" file extension 
names <-gsub('.{4}$', '', filenames) # deletes last four characters

# Load all files as dataframes
for(i in names){
  filepath <- file.path("./data/csv/",paste(i,".csv",sep=""))
  assign(i, read.delim(filepath, sep = "," ,na.strings='NULL'))
}
```

## Loading lots of csvs into a single data frame

Sometimes you may have many csv files with some sort of common name that you want to combine into a single data frame.

```r
setwd("./data/csv/")
temp = list.files(pattern="*Hourly.csv")
myfiles = lapply(temp, read.delim, sep=",")
TOTALhourly <- do.call(rbind, myfiles)
```

## Loading an excel file

```r
data <- read_excel("./data/xlsx/FILE.xlsx") # loads the first sheet by default, requires readxl library
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

## Wide to long format

This example is a common case where data is sourced with a single Date column with the variables you are interested in separated across multiple columns.  Ideally here you want a single date column and a single variable column.  This assumes that the Date column is a factor at the time the script is run (i.e. has not yet been converted to a date format in R):

```r
# reshape data from wide to long format
library("reshape2")  
data <- reshape2::melt(data, id.vars = c("Date"))
```

## Changing the order of data

```r
data <- data[order(data$YOURVARIABLENAME), ] # order data
```

find position in order:

```r
which(data$YOURVARIABLENAME=="LABEL") # find position
```

Use this to change the order that variables will be shown in charting:

```r
data$YOURVARIABLENAME <- factor(data$YOURVARIABLENAME, levels = c("YOURVARIABLECAT1", "YOURVARIABLECAT1", "YOURVARIABLECAT1")) # change order for key

```

## Stacking data

```r
data <- stack(data) # transform separate columns into a single vector with two columns (values and ind)
```

## Cleaning imported data

Files sourced in a corporate environment are often messy.

We will need to make sure that numeric csv data is cleansed of common extraneous characters (commas, pound signs etc.) that would cause problems with analysis in R.

#### Using gsub

One approach is to use gsub which replaces all matches of a particular character (string).  Examples:

```r
data$'YOUR VARIABLE NAME' <- gsub(",", "", paste(data$'YOUR VARIABLE NAME')) # remove "," in a specific variable
```

```r
data[] <- lapply(data, gsub, pattern=',', replacement='') # remove "," throughout dataframe
```

#### Trim white space

```r
data$YOURVARIABLENAME < - trimws(data$YOURVARIABLENAME, "both") # trims white space either side of string
```

#### Create a new field with values of other fields
```r
library(dplyr)

# create labels based on the values of other fields (requires dplyr)
data <- data %>%
  mutate(NEWFIELD = case_when(FIELD1 > 0 ~ "LABEL1",
                                FIELD2 > 0  ~ "LABEL2"))
data$Type <- as.factor(data$NEWFIELD)
```

#### Creating a dummy variable

```r
data$DUMMYVARIABLE <- as.numeric(data$COLUMNNAME == "CONDITION")
```

#### Adding a column of 1s

```r
data$count <- rep(1,nrow(data)) # make new column of 1s
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
And:

```r
data[data == 0] <- NA # replace 0 with NA
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

To remove rows that contain specific content:

```r
data <- data[!(data$YOURVARIABLENAMEr=="The value you don't want"),]# this is a factor so...
data$Member <- factor(data$YOURVARIABLENAME) # ...restore correct levels
```

## Tidy column headings (variable names)

```r
names(data)[names(data) == 'YOUROLDNAME'] <- 'YOURNEWNAME'
```

## Using the first row as column headings (variable names)

```r
# tidying so that first row is the heading
data <- data[-1, ] # remove row so correct header row is now in row 1
names(data) <- as.matrix(data[1, ])
data <- data[-1, ]
data[] <- lapply(data, function(x) type.convert(as.character(x)))
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

If you just have a year but want to treat it as a date:

```r
data <- transform(data,
                  Year = as.Date(paste(Year,"-01-01",sep=""))) # adding month and day to Year so can use as date
```r

### Lubridate

Perhaops an easier alternative is to use the lubridate library which can deal with a wide format of dates.  For example:

```r
data$Date <- dmy(data$Date) # requires lubridate
```

This for me dealt with data that contained th, st, rd and nd suffixes to the dates.  Alternate options are available such as ```mdy_hm```.

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
Alternatively:

```r
data <- aggregate(data[ ,3], FUN="sum", by=list(as.Date(data$Date, "%Y-%m-%d"))) # col 3 is the Result to be summed
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

## Remove cases from one data frame if they are present in the other

```r
CASESINONEBUTNOTINTWO <- ONE[!ONE$Number %in% TWO$Number,] # remove cases from ONE that are also in TWO
```

## Vertical joins (stacking) data frames

To stack one dataframe on top of another, make sure that the number of columns and names are identical and then:

```r
merged <- rbind(DATAFRAME1, DATAFRAME2)
```

## Other useful operations

### Select first or last number

```r
as.numeric(tail(data$YOURVARIABLE,1))
```
Use ```head``` to select first.

### Rolling sum

```r
rollsumr(data$YOURVARIABLE, k = 6, fill = NA)# sum six rows
```

### Sum to weekly

```r
data <- as.xts(data$value,order.by=as.Date(data$Date)) # requires xts package
weekly <- apply.weekly(data,sum) # sum to weekly 
weekly <- data.frame(Date=index(weekly), coredata(weekly)) # convert xts to dataframe
```

### Combine text and variables

e.g. making a caption:

```r
caption <-paste("YOURTEXTHERE",YOURVARIABLE, " ", ANOTHERVARIABLE, " MORETEXT.","\nMORETEXT",sep = "")
```

Note ```\n``` is used to more the text onto a new line.

## Exporting to csv

```write.csv(data, file = "FILENAME.csv")```

## Exporting plots


### Plot dimensions

One of the big advantages of using R to produce dataviz is the consistency that can be achieved from one plot to the next.

I would suggest using three aspect ratios depending on the plot and the context in which it will be viewed:

* 16:10
* 4:3
* square

A 16:10 aspect ratio tends to work well for plots to be included within a document and also for presentations.

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

# RDataViz

Examples of data viz using R with an emphasis on good practice in visual design for a 'corporate' rather than scientific audience.

All examples tested with R version 3.4.0 and assume that R Studio is being used, tested with version 1.0.143.

## Acknowledgements

The code shared here is generally based on the work of others found on the web.  I have tried to attribute the sources used but let me know if you feel I should credit your work.

### Recommended reading

Tufte, Edward R (1983), The Visual Display of Quantitative Information.

Few, Stephen (2012), Show Me The Numbers.

### R

My thanks to the R core team and to the authors of the libraries used in the examples:

R Core Team (2017). R: A language and environment for statistical computing. R
  Foundation for Statistical Computing, Vienna, Austria. https://www.R-project.org/

### ggplot2

H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2009. http://ggplot2.org

### ggmap

D. Kahle and H. Wickham. ggmap: Spatial Visualization with ggplot2. The R Journal, 5(1), 144-161. http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf

### ggthemes

Jeffrey B. Arnold (2017). ggthemes: Extra Themes, Scales and Geoms for 'ggplot2'. R
  package version 3.4.0. https://CRAN.R-project.org/package=ggthemes

### googleVis

Markus Gesmann and Diego de Castillo. Using the Google Visualisation API with R. The R Journal, 3(2):40-44, December 2011.

### scales

Hadley Wickham (2016). scales: Scale Functions for Visualization. R package version 0.4.1 https://CRAN.R-project.org/package=scales

### treemapify

David Wilkins (2017). treemapify: Draw treemaps easily. R package version 2.2.2. https://github.com/wilkox/treemapify


## Data viz: general tips

### R tips

This section is not intended to provide a comprehensive primer for R.  Rather it is a collection of the useful tips that the data viz examples use and an opportunity to explain why they are used.

#### Working directory

For simplicity, I would suggest keeping your R scripts and data sources in the same directory.  If you do, the following code can be used in your scripts to set your working directory to the location of the R script.  This will help ensure that your work is easily portable for others:

```r
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # set working directory
```

*Note*: this requires R studio to be used and the rstudioapi library to have been previously installed.

#### Loading libraries

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

In this case ggplot2, ggthemes, ggmap and scales will be loaded or installed and then loaded if not already present.

#### Loading data

The examples given here use R's in-built datasets to ensure reproducibility.

Each example loads a dataset as data frame  "data".  To replace this with your own csv data, comment out or delete the existing line that creates the data frame "data" and use the following code instead:

```r
data <- read.csv("YOURFILENAME.csv",header=TRUE, sep = ',') # Read csv file, change YOURFILENAME
```

#### Cleaning imported data

By defining and using a clean function we can make sure that numeric csv data is cleansed of common extraneous characters that would cause problems with analysis in R.

To apply to the entire data frame of variables (be careful in using this as it will bork any variables in your data frame which you need to be non-numeric):

```r
clean <- function(ttt){
as.numeric( gsub('[^a-zA-Z0-9.]', '', ttt))
}
data[] <- sapply(data, clean)
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



#### Working with dates

You need to be explicit about date formats in R.  Use as.Date to tell R to change a field in your data frame to a particular date format. 

###### DMY

e.g. date in format dd/mm/yyyy:

```r
data$YOURVARIABLENAME <- as.Date(data$YOURVARIABLENAME, "%d/%m/%Y") # transform a field name to dd/mm/yyyy, change text in capitals
```


###### YMD

e.g. date in format [yyyy-mm-dd](https://xkcd.com/1179/):

```r
data$YOURVARIABLENAME <- as.Date(data$YOURVARIABLENAME, "%Y-%m-%d") # transform a field name to yyyy-mm-dd, change text in capitals
```

Note the substitution of '/' with '-' in this example.

#### Suppressing scientific notation

We are producing data viz for business here and so it is useful to suppress scientific notation, i.e. we would rather show one million as 1,000,000 than as 1e6.  To get part of the way towards this use the following code in your R script prior to plotting:

```r
options(scipen=999) # supress scientific notation
```

With scientific notation suppressed, one million will be shown by R as 1000000.  We will need to use a further line of code in our plots to also show comma separators.


#### Working with colour

Colour choice matters.  I recommend either sticking with a colour blind safe colour pallete or creating a restrained colour pallete based on one or two colours.  Think about what you are trying to communicate through your charts and use colour to emphasise this.


##### Colour blind safe colours

The scales library provides good colour blind friendly palletes based on those provided by Tableau.  To view this pallete use:

```r
library("scales")
show_col(tableau_color_pal('colorblind10')(10))
```

To use in your plots, add the following line as part of your ggplot:

```r
scale_colour_tableau(name = "","colorblind10") # use Tableau colour blind pallete
```


##### Getting a range of colours

A quick method to get a range of colours:

```r
colfunc <- colorRampPalette(c("#8E0A26", "white")) # Create colour gradient between two colours
colfunc(6) # print 6 colours in the range
colfunc(20) # print 20 colours in the range
```

##### Defining colour scales


###### Continuous scales


###### Discrete scales


#### Exporting plots

##### Plotting to file

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


##### Using knitr 

Knitr documents are written in Markdown or in LaTeX.  Knitr enables export to a variety of file formats via Pandoc.  My preference is to use LaTeX to PDF.  To use LaTeX and Pandoc you will need to install them separately first:

https://www.latex-project.org/get/

http://pandoc.org

To use knitr make sure that knitr instead of sweave is selected in R studio under options to 'Weave Rnw files using:'

##### Proportions

One of the big advantages of using R to produce dataviz is the consistency that can be achieved from one plot to the next.

I would suggest using two (and only two) aspect ratios depending on the plot and the context that it will be viewed:

* 16:9
* 4:3

A 16:9 aspect ratio tends to work well for plots to be included within a document and also for presentations.

A 4:3 aspect ratio works well for plots that will be viewed full-screen on a tablet which is common in a corporate setting.

### ggplot2 key techniques

Most of the examples shown here use ggplot2.


#### Getting the gist of ggplot2

The concept at the heart of ggplot2 is that graphics are comprised of individual elements that can be layered on top of each other. 

A ggplot graphic is therefore built up by lines of code which layer each element in the graphic.

It's a powerful idea and can be used to simply build extremely good charts.

For example, the following code produces a basic line plot:

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_line() # adding a line
```

By adding  line we can add a title to the basic plot:

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_line() + # adding a line
  ggtitle("Average Heights and Weights for American Women") # adding a title
```

We can then add another line to include a text annotation:

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_line() + # adding a line
  ggtitle("Average Heights and Weights for American Women") + # adding a title
  annotate("text", label="Median\nweight", x=median(data$weight), y=60, size=3)  # adding an annotation
```

As you can see, each new line of code that adds a new layer should follow a '+'.

There are different schools of thought about the positioning of the '+'.  I prefer to add the '+' at the end of the previous line rather than at the beginning of the current line YMMV.

Some useful layers:

##### Show the data points

```r
geom_point(size = 1.1) 
```

##### Manually add a point

```r
annotate("point", x = 130, y = 70)
```

##### Add a point with a range

```r
annotate("pointrange", x = 125, y = 59, ymin = 58, ymax = 60)
```

##### Vertical line

```r
geom_vline(xintercept = median(data$weight), linetype="dashed") 
```

##### Horizontal line
```r
  geom_hline(yintercept = median(data$height), linetype="dotted") 
```

##### Text annotation

```r
annotate("text", label="Median height", x=120, y=median(data$height), size=3) + # adding an annotation
```

##### Shaded rectangle

```r
annotate("rect", xmin = 150, xmax = 160, ymin = 67, ymax = 73, alpha = .1)
```

##### Fitted line

```r
geom_smooth(method = "lm", se=FALSE) 
```


##### Fitted formula

```r
stat_smooth(method="lm",formula=y ~ x + I(x^2), se=FALSE) # add fitted line based on formula
```

#### Titles and subtitles

ggtitle("A title", subtitle = "A subtitle")


##### Using a variable in a title or subtitle

Set it up first before your ggplot:

```r
today <- format(Sys.time(), "%d/%m/%Y") # Create variable with today's date
chart_sub <- paste("Chart produced on", today) # Create a subtitle including variable 'today'
```
Then within your ggplot:

```r
ggtitle("Average Heights and Weights for American Women", subtitle = paste0(chart_sub))
```

#### Commas in scales

Use the scales library to easily add commas to the axis of plots that need them.

For the x axis:

```r
scale_x_continuous(labels = comma) # Assumes scales library is loaded
```

For the y axis:

```r
scale_y_continuous(labels = comma) # Assumes scales library is loaded
```

#### ggthemes

The ggthemes library presents themes for the overall aesthetic of a plot made in ggplot2.  The templates are based on good practice examples such as High Charts, Tableau and The Economist... and even some not-so-good practice, tongue-in-cheek examples like Excel!

I like to use the High Charts theme as it has a good [data ink](http://www.darkhorseanalytics.com/blog/data-looks-better-naked) ratio.  I use different colours than the default choices however.

To use the High Charts theme in a ggplot, add the following line of code:

```r
theme_hc() # Use High Charts theme, assumes ggthemes is loaded
```


## Tables

LaTeX "booktabs" style tables are the way to go for the best looking tables possible.  A few different R libraries make this possible but I've had the best results with Kable and Kableextra.

### Using Kable and Kableextra

The Kableextra library gives really nice results, see:  https://github.com/haozhu233/kableExtra

Make sure you are using Knitr (i.e. your file should be saved as a .Rnw file).

```r
<<Demo Table>>=
library(kableExtra) # Assuming that knitr library is already loaded
data <- mtcars[1:5, 1:6]
options(knitr.table.format = "latex")
kable(data, longtable = T, booktabs = T, caption = "This is a table.")%>%
  kable_styling(font_size = 10)
@
```


## Line chart



## Column / Bar chart


### Grouping


### Gantt chart


## Scatter plot


### Fitting scatter plots




## Histogram


## Boxplot


### Violin plot

A violin plot is a variation on a box plot.

## Sankey diagram


## Bullet chart

Concept by Stephen Few, R Implementation by Simon Müller.

## Treemap


## Maps

### Points

### Bubbles

### Density





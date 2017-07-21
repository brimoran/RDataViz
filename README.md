# RDataViz

Examples of data viz using R with an emphasis on good practice in visual design for a 'corporate' rather than scientific audience.

All examples assume that R Studio is being used.

## Acknowledgements

The code is generally based on the work of others found on the web.  I have tried to attribute the sources used but let me know if you feel I should credit your work.

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

### ggplot2 key techniques

Most of the examples shown here use ggplot2.


#### Aesthetics


Add to ggplot following a '+'.

##### Text annotation

```r
annotate("text", label="Forecast", x=2017.5, y=77000, size=3)
```


##### Shaded rectangle

```r
annotate("rect", xmin = 2017, xmax = 2018, ymin = 0, ymax = 80000, alpha = .1)
```


##### A vertical line:

e.g.

```r
geom_vline(xintercept = 60528, color = "#8e0a26", linetype="dashed")
```

#### Titles and subtitles

### Suppress scientific notation

We are producing data viz for business here and so it is useful to suppress scientific notation.  To do so use the following code in your R script prior to plotting:

```r
options(scipen=999) # supress scientific notation
```

### Working with colour

#### Getting a range of colours

A quick method to get a range of colours:

```r
colfunc <- colorRampPalette(c("#8E0A26", "white")) # Create colour gradient between two colours
colfunc(6) # print 6 colours in the range
colfunc(20) # print 20 colours in the range
```

#### Defining colour scales


##### Continuous scales


##### Discrete scales


#### Colour blind safe colours

The scales library provides good colour blind friendly palletes based on those provided by Tableau.  To view this pallete use:

```r
library("scales")
show_col(tableau_color_pal('colorblind10')(10))
```

To use in your plots, add the following line as part of your ggplot:

```r
scale_colour_tableau(name = "","colorblind10") # use Tableau colour blind pallete
```

### Commas in scales



### Working with dates

#### DMY


#### YMD


### Exporting plots



#### Plotting to file

As a vector format, the PDF file format offers high fidelity output.  PDF files can prove difficult to print however if they use excessive transparencies, e.g. a map with thousands of overlaid semi-transparent points will probably fail to flatten when printing.  In such cases a better choice would be to use a raster format such as a PNG file.

#### Output to PDF

```r
pdf(file="FILENAME.pdf", width = 8, height = 4.5) # Prepare to output PDF with 16 by 9 ratio, change FILENAME accordingly

# YOUR PLOT HERE

dev.off() # output file
```

#### Output to PNG


```r
png(file="FILENAME.png", width = 1600, height = 900) # 16 by 9 ratio, change FILENAME accordingly

# YOUR PLOT HERE

dev.off() # output file
```


#### Using knitr 

Knitr documents are written in Markdown or in LaTeX and enables export to a variety of file formats via Pandoc.  My preference is to use LaTeX to PDF.


## Tables

LaTeX "booktabs" style tables are the way to go.  A few different R libraries make this possible but I've had the best results with Kable and Kableextra.

### Using Kable and Kableextra

The Kableextra library gives really nice results, see:  https://github.com/haozhu233/kableExtra

Makes sure you are using Knitr (i.e. your file should be saved as a .Rnw file).

```r
<<Demo Table>>=
library(kableExtra) # Assuming that knitr library is already loaded
data <- mtcars[1:5, 1:6]
options(knitr.table.format = "latex")
kable(dt, longtable = T, booktabs = T, caption = "This is a table.")%>%
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





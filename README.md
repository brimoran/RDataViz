# RDataViz
Examples of data viz using R with an emphasis on good practice in visual design.

All examples assume that R Studio is being used.

## Acknowledgements

The code is generally based on the work of others found on the web.  I have tried to attribute the sources used but let me know if you feel I should credit your work.

My thanks to the R core team and to the authors of the libraries used in the examples:

### R

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

### Suppress scientific notation

Often it is useful to suppress scientific notation.  To do so use the following code in your R script prior to plotting:

```r
options(scipen=999) # supress scientific notation
```

### Commas in scales


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

The ggthemes library provides good colour blind friendly palletes based on those provided by Tableau.  To view this pallete use:

```r
library("scales")
show_col(tableau_color_pal('colorblind10')(10))
```

To use in your plots, add the following line as part of your ggplot:

```r
scale_colour_tableau(name = "","colorblind10") # use Tableau colour blind pallete
```


### Working with dates

#### DMY


#### YMD


### Exporting plots


#### Using knitr 


#### Plotting to file

PDF is preferred.

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





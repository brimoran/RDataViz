# RDataViz
Examples of data viz using R with an emphasis on good practice in visual design.

All examples assume that R Studio is being used.

## Acknowledgements

The code is generally based on the work of others found on the web.  I have tried to attribute the sources used but let me know if you feel I should credit your work.

My thanks to the R core team and to the authors of the libraries used in the examples:

### ggplot2

### ggmap

### ggthemes

### scales

### treemapify





## General Tips

### Suppress scientific notation

Often it is useful to suppress scientific notation.  To do so use the following code in your R script prior to plotting:

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



#### Colour blind safe colours



### Working with dates



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



## Treemap


## Gantt chart

## Maps

### Points

### Bubbles

### Density





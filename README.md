# RDataViz
Examples of data viz using R with an emphasis on good practice in visual design.

All examples assume that R Studio is being used.

All examples are cobbled together from the work of others found on the web.  I'll try to attribute the source of code used but let me know if I miss this. 

##Tips

###Suppress scientific notation

```r
options(scipen=999) # supress scientific notation
```

###Working with colour

####Getting a range of colours

A quick method to get a range of colours:

```r
# Getting a range of colours

colfunc <- colorRampPalette(c("#8E0A26", "white")) # Create colour palette between two colours
colfunc(20) # print 20 colours in the range
```

#### Defining colour scales



#### Colour blind safe colours



### Working with dates



##Line chart




##Column / Bar chart


###Dodging


##Scatter plot



##Histogram


##Boxplot


###Violin plot

A violin plot is similar to a no plot 

##Sankey diagram



##Maps

###Points

###Bubbles

###Density



##Bullet chart



##Treemap





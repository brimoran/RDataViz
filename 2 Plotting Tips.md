### Plotting key techniques

Most of the examples shown here use ggplot2.


#### Getting the gist of ggplot2

The concept at the heart of ggplot2 is that graphics are comprised of individual elements that can be layered on top of each other. 

A ggplot graphic is therefore built up by lines of code which layer each element in the graphic.

It's a simple but powerful idea and can be used to build extremely good charts.

For example, the following code produces a basic line plot:

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_line() # adding a line
```
The first line loads the data, in this case one of R's in-built datasets.  The second line tells ggplot which data source to use and outlines the basic aesthetics "aes" for the plot.  The third line adds a geometric shape "geom" to the plot.


By adding a further line of code we can add a title to the basic plot.  Note the addition of the '+':

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_line() + # adding a line
  ggtitle("Average Heights and Weights for American Women") # adding a title
```

We can then add another line to include a text annotation.  Again note the '+':

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_line() + # adding a line
  ggtitle("Average Heights and Weights for American Women") + # adding a title
  annotate("text", label="Median\nweight", x=median(data$weight), y=60, size=3)  # adding an annotation
```

Each new line of code that adds a new layer should follow a '+'.

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

```r
ggtitle("A title", subtitle = "A subtitle")
```

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


#### ggthemes

The ggthemes library presents themes for the overall aesthetic of a plot made in ggplot2.  The templates are based on good practice examples such as High Charts, Tableau and The Economist... and even some not-so-good practice, tongue-in-cheek examples like Excel!

I like to use the High Charts theme as it has a good [data ink](http://www.darkhorseanalytics.com/blog/data-looks-better-naked) ratio.  I use different colours than the default choices however.

To use the High Charts theme in a ggplot, add the following line of code:

```r
theme_hc() # Use High Charts theme, assumes ggthemes is loaded
```

#### Scales


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

#### Facets

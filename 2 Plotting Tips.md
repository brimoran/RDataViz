# Plotting tips

Most of the examples shown here use ggplot2.


## Getting the gist of ggplot2

The concept at the heart of ggplot2 is that graphics are comprised of individual elements that can be layered on top of each other. 

A ggplot graphic is therefore built up by lines of code which layer each element in the graphic.

It's a simple but powerful idea and can be used to build extremely good charts.

For example, the following code produces a basic scatter plot:

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_point() # adding the points
```

The first line loads the data, in this case one of R's in-built datasets.  The second line tells ggplot which data source to use and outlines the basic aesthetics "aes" for the plot.  The third line adds a geometric shape "geom" to the plot to represent the data.

By adding a further line of code we can add a title to the basic plot.  Note the addition of the '+':

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_point() + # adding the points
  ggtitle("Average Heights and Weights for American Women") # adding a title
```

We can then add another line to include a text annotation.  Again note the '+':

```r
data <- women # load data

ggplot(data, aes(x = weight, y = height)) +
  geom_point() + # adding the points
  ggtitle("Average Heights and Weights for American Women") + # adding a title
  geom_text(aes(x=140, y=68, label="My text"), color = "black",
            size = 5, angle = 45) # adding an annotation
```

Each new line of code that adds a new layer should follow a '+'.

There are different schools of thought about the positioning of the '+'.  I prefer to add the '+' at the end of the previous line rather than at the beginning of the current line YMMV.

Some useful layers:

### Show a line through the data

```r
geom_line()
```

### Show the data points

```r
geom_point(size = 1.1) 
```

### Manually add a point

```r
annotate("point", x = 130, y = 70)
```

### Add a point with a range

```r
annotate("pointrange", x = 125, y = 59, ymin = 58, ymax = 60)
```

### Vertical line

```r
geom_vline(xintercept = median(data$weight), linetype="dashed") 
```

### Horizontal line
```r
geom_hline(yintercept = median(data$height), linetype="dotted") 
```

### Text annotation

```r
 geom_text(aes(x=140, y=68, label="My text"), color = "black",
            size = 5, angle = 45) # adding an annotation
```

or from using a dataframe:

```r
  geom_text(data=annotation, aes( x=x, y=y, label=label), color="#ffa4a2", size=3) + # adding an annotation
```

### Shaded rectangle

```r
  geom_rect(mapping=aes(xmin=100, xmax=110, ymin=0, ymax=12), alpha=.1)
```

### Fitted linear line

```r
geom_smooth(method = "lm", se=FALSE) 
```

### Fitted formula

```r
stat_smooth(method="lm",formula=y ~ x + I(x^2), se=FALSE) # add fitted line based on formula
```

### Titles and subtitles

```r
ggtitle("A title", subtitle = "A subtitle")
```

#### Using a variable in a title or subtitle

Set it up first before your ggplot:

```r
today <- format(Sys.time(), "%d/%m/%Y") # Create variable with today's date
chart_sub <- paste("Chart produced on", today) # Create a subtitle including variable 'today'
```
Then within your ggplot:

```r
ggtitle("Average Heights and Weights for American Women", subtitle = paste0(chart_sub))
```

## ggthemes

The ggthemes library presents themes for the overall aesthetic of a plot made in ggplot2.  The templates are based on good practice examples such as High Charts and The Economist... and even some not-so-good practice, tongue-in-cheek examples like Excel!

I like to use the High Charts theme as it has a good [data ink](http://www.darkhorseanalytics.com/blog/data-looks-better-naked) ratio.  I use different colours than the default choices however.

To use the High Charts theme in a ggplot, add the following line of code:

```r
theme_hc() # Use High Charts theme, assumes ggthemes is loaded
```

## Scales

### Commas in scales

Use the scales library to easily add commas to the axis of plots that need them.

For the x axis:

```r
scale_x_continuous(labels = comma) # Assumes scales library is loaded
```

For the y axis:

```r
scale_y_continuous(labels = comma) # Assumes scales library is loaded
```

### Specifying breaks 

To state what you want:

```r
scale_x_continuous(breaks=c(2016, 2017, 2018, 2019))
```

To calculate a range:

```r
scale_x_continuous(breaks=seq(0, 300, by = 10))
```

### Specifying limits

This provides some extra padding either side on the x axis:

```r
scale_x_date(date_breaks = "3 month", 
              labels=date_format("%b-%Y"), 
              limits = as.Date(c(min((data$Date)-31),(max(data$Date)+31)))) +
```

### Specifiying number of decimal places

```r
  scale_y_continuous(labels = scales::number_format(accuracy = 0.1, decimal.mark = '.')) 
```

## Facets


## Working with colour

Colour choice matters.  I recommend either sticking with a colour blind safe colour pallete or creating a restrained colour pallete based on one or two colours.  Think about what you are trying to communicate through your charts and use colour to emphasise this.


### Colour blind safe colours

The ggthemes package provides good colour blind friendly palletes based on those provided by Tableau and by [Paul Tol](https://personal.sron.nl/~pault/).

To view the Tableau pallete use:

```r
library("scales") # To use show_col
library("ggthemes")
show_col(tableau_color_pal('colorblind10')(10))
```

To view the Paul Tol pallete use:

```r
library("scales") # To use show_col
library("ggthemes")
show_col(ptol_pal()(9))
```

Google Material Design equivalents to Paul Tol colours:

```r
#Google Material Design colours closest to Paul Tol (4 colour pallete for maps)
factpal <- colorFactor(
  palette = c('#9e9e9e','#3f51b5', '#f06292','#d4e157','#2e7d32'),
  domain = data$YOURVARIABLENAME)
```

### Getting a range of colours

A quick method to get a range of colours:

```r
colfunc <- colorRampPalette(c("#8E0A26", "white")) # Create colour gradient between two colours
colfunc(6) # print 6 colours in the range
colfunc(20) # print 20 colours in the range
```

### Defining colour scales

Setting specific colours:

```r
# An orange-blue gradient based on Google's material design pallete https://material.io/guidelines/style/color.html
materialOrgBlu <- c("#e65100", "#ef6c00","#f57c00", "#fb8c00","#ff9800","#ffa726", "#ffb74d", "#ffcc80","#ffe0b2","#fff3e0",
            "#e3f2fd","#bbdefb", "#90caf9","#64b5f6","#42a5f5","#2196f3","#1e88e5","#1976d2", "#1565c0","#0d47a1")
```

Create a colour function to be used in your own scales.

A gradient:

```r
colPalette <- colorRampPalette(c("#8E0A26", "white")) # set up colour function based on corporate colour, in this case #8E0A26
```

e.g. Using Tableau colour blind scheme:

```r
colPalette <- c(tableau_color_pal('colorblind10')(10)) # assumes scales package is loaded
```

Then use, for fills:

```r
  scale_fill_manual(values=colPalette)
```

Or for points and lines:

```r
  scale_colour_manual(values=colPalette) 
```

#### Continuous scales


#### Discrete scales

#### Rotate axis labels

```r
theme(axis.text.x = element_text(angle = 90, hjust = 1)) + # rotate x axis labels
```

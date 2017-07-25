# Overview of Examples

This section summarises the examples contained in the "Examples" folder.

## Tables

See Table.Rnw

Sorry to begin with an example that requires some understanding of LaTeX but LaTeX "booktabs" style tables are the way to go for the best looking tables possible and hopefully the LaTeX elements are explained clearly enough.

A few different R packages make it possible to automate booktabs style tables, but my preference is using Kable and Kableextra.

For the example to work make sure you are able to use Knitr in your R installation (see section 3 Knitr Tips).

The key part of the code is this knitr chunk:

```r
<<Your reference to the chunk>>=
library(kableExtra) # Assuming that knitr library is already loaded
data <- mtcars[1:5, 1:6]
options(knitr.table.format = "latex")
kable(data, longtable = T, booktabs = T, caption = "This is a table.")%>%
  kable_styling(font_size = 10)
@
```

Thanks to cmhughes for explaining how to format table captions in LaTeX, see: http://tex.stackexchange.com/questions/86120/font-size-of-figure-caption-header

## Line chart

Two examples are provided with different colour schemes:

* Line_chart_corporate_colours.R; and 
* Line_chart_colour_blind.R

The key section of the code is:

```r
ggplot(data, aes(x = Year, y = Result, group = Variable, color = Variable)) +
  geom_line() +
  geom_point(size = 1.1) + 
  ggtitle("Your Title") +
  labs(x = "Year", 
       y = "Units") +
  theme_hc()
```

The full scripts demonstrates:

* Custom colours
* Commas in the y scale
* Fixed breaks in the x scale
* Saving output to PDF

## Column / Bar chart

To do.

### Grouping

To do.

### Gantt chart

To do.

## Scatter plot

To do.

## Histogram

To do.

## Boxplot

To do.

### Violin plot

To do.

A violin plot is a variation on a box plot.

## Sankey diagram

To do.

## Bullet chart

To do.

Concept by Stephen Few, R Implementation by Simon Müller.

## Treemap

To do.

## Maps

To do.

### Points

### Bubbles

### Density




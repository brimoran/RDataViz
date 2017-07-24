# Overview of Examples

This section summarises the examples contained in the "Examples" folder.

## Tables

See Table.Rnw

LaTeX "booktabs" style tables are the way to go for the best looking tables possible.  A few different R packages make this possible but I've had the best results with Kable and Kableextra.

### Using Kable and Kableextra

To do.

The Kableextra package gives really nice results, see:  https://github.com/haozhu233/kableExtra

Make sure you are using Knitr (i.e. your file should be saved as a .Rnw file).

The key part of the code is:

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

Two examples are provided with different colour schemes:

* Line_chart_corporate_colours.R; and 
* Line_chart_colour_blind.R

The key section of the code is:

```
ggplot(data, aes(x = Year, y = Result, group = Variable, color = Variable)) +
  geom_line() +
  geom_point(size = 1.1) + 
  ggtitle("Your Title") +
  labs(x = "Year", 
       y = "Units") +
  theme_hc()
```r

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




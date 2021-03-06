# Overview of Examples

This section summarises the examples contained in the "Examples" folder.

## Tables

See Table.Rnw

Sorry to begin with an example that requires some understanding of LaTeX but LaTeX "booktabs" style tables are the way to go for the best looking tables possible and hopefully the LaTeX elements are explained clearly enough.

A few different R packages make it possible to automate booktabs style tables, but my preference is using Kable and Kableextra.

For the example to work make sure you are able to use Knitr in your R installation (see section 3 Knitr Tips).

**If you are copying and pasting code rather than downloading my files make sure that you are working in a Rnw file in R Studio: File > New Sweave File.  To run the code,click on the 'Compile PDF' button in R Studio.**

The key part of the code to build the table is within the knitr chunk: ```<<Your reference to the chunk>>=```

```r
options(knitr.table.format = "latex")
kable(data, longtable = T, booktabs = T, caption = "This is a table.")%>%
  kable_styling(font_size = 10)
```

The full script demonstrates:

* Setting global options in knitr so that code is not displayed in the rendered PDF.
* Controlling the format of table captions.
* Removing page numbers from the rendered PDF.

Thanks to cmhughes for [this helpful post](http://tex.stackexchange.com/questions/86120/font-size-of-figure-caption-header) which taught me how to format table captions in LaTeX. 


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




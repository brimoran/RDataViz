# knitr tips 

knitr documents are written in Markdown or in LaTeX.  knitr enables export to a variety of file formats via Pandoc.  My preference is to use LaTeX to PDF.  To use LaTeX and Pandoc you will need to install them separately first:

https://www.latex-project.org/get/

http://pandoc.org

To use knitr make sure that knitr instead of sweave is selected in R studio under options to 'Weave Rnw files using:'

## Declaring a knitr chunk

To declare knitr chunks of R code within you Rnw file surround the R code as folows:

```r
<<YOURREFF>>=

# YOUR R CODE HERE

@
```

## Chunk settings


## Setting global options


### Figure names

Use: ```r fig.cap="YOUR CAPTION"```

Within the head of the chunk  ```r <<>>=``` after your chunk name.

### Plot size

Use:  ```r fig.width = 8, fig.height = 4.5```

Within the head of the chunk ```r <<>>=``` after your chunk name.


### Dependancies

You can make one knitr chunk dependent on another chunk.  This is a useful approach to take when using CSV data.  The following example will ensure that CSV data is reloaded by knitr if it is modified.

First read the CSV file in one chunk.

```r
<<YOURREFtime, cache=TRUE, data_time=file.info("YOUR.csv")$mtime>>=
#getdata (reread if file has been updated)
data <- read.csv("YOUR.csv",header=TRUE) # Read csv file. 
@
```
Then:

```r
<<YOURREF, fig.cap="YOUR CAPTION", fig.width = 8, fig.height = 4.5, dependson='YOURREFtime'>>=

# YOUR PLOT HERE
@
```
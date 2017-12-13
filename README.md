# dull

A new approach to building Shiny applications. dull is not intended to replace 
shiny, dull builds upon shiny by providing updated versions of reactive inputs 
and outputs, brand new reactive inputs, and new reactive thruputs, controls
which are both inputs and outputs. dull is an exciting new tool for those who
have love working shiny.

## Introduction

dull is built on top of shiny's reactive engine and bootstrap 4. Additional
libraries used include the Font Awesome icon set, aftertheflood's Spark font,
and the ion range slider. The package provides a new approach to many of the
functionalities provided by shiny. Because dull overwrites the Bootstrap 3
resources of shiny many new replacement `*Input` functions are included as part
of dull.

## Motivation

dull is an effort to provide the user more flexibility and open up new, creative
possibilities for shiny based applications.
Additionally, I believe shiny's evolution has locked in paradigms that might not
exist if the developers could start with a clean slate. dull hopes to be that
clean slate and much of what I sought to build into dull I later found mirrored
in requests (some of those [here](https://github.com/nteetor/dull/issues/13)) to
the shiny development team.

## Installation

dull is still a work in progress and may be downloaded using
`devtools::install_github`.

```R
devtools::install_github("nteetor/dull")
```

## Examples

These examples are adapted from the 
[start simple](https://shiny.rstudio.com/gallery/#start-simple) section of the
shiny gallery.

#### k means

See the original, pure shiny version 
[here](https://shiny.rstudio.com/gallery/kmeans-example.html).

```R
library(dull)

shinyApp(
  ui = container(
    row(
      col(
        default = 12,
        h1("Iris k-means clustering")
      ),
      col(
        default = 4,
        col(
          h6("X variable"),
          selectInput(
            id = "xcol",
            options = names(iris)
          ),
          h6("Y variable"),
          selectInput(
            id = "ycol",
            options = names(iris),
            selected = names(iris)[[2]]
          ),
          h6("Cluster count"),
          numberInput(
            id = "clusters",
            value = 3,
            step = 1, 
            min = 1,
            max = 9
          )
        ) %>% 
          padding(4, 2, 4, 2) %>% 
          background("light") %>% 
          border(rounded = "all")
      ),
      col(
        plotOutput("plot1")
      )
    )  
  ),
  server = function(input, output) {
    validateEvent(input$clusters, {
      req(input$clusters)
      
      if (input$clusters < 1) {
        stop("must be greater than or equal to 1")
      }
      
      if (input$clusters > 9) {
        stop("must be less than or equal to 9")
      }
    })
    
    selectedData <- reactive({
      iris[, c(input$xcol, input$ycol)]
    })
  
    clusters <- reactive({
      kmeans(selectedData(), input$clusters)
    })
    
    output$plot1 <- renderPlot({
      palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
        "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
  
      par(mar = c(5.1, 4.1, 0, 1))
      
      plot(selectedData(), col = clusters()$cluster, pch = 20, cex = 3)
           
      points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    })
  }
)
```

## Reactive Controls

These reactive controls are included in the package.

### Inputs

* `buttonInput`
* `checkboxInput`
* `rangeInput`, similar to `shiny::sliderInput`
* `intervalInput`, like `rangeInput`, but with two slider controls
* `sliderInput`, like `rangeInput`, but handles custom string values and choices
  instead of numeric values
* `colorInput`
* `radioInput`
* `dateInput`
* `datetimeInput`
* `emailInput`
* `formInput`, a new input made up of any number of _dull_ reactive inputs and a
  submit button. The bundled inputs lose their reactivity. Instead their values
  make up the value of the form input. The form input value is updated when the
  submit button is clicked.
* `groupInput`
* `monthInput`
* `numberInput`
* `passwordInput`
* `radioInput`
* `searchInput`
* `selectInput`
* `telephoneInput`
* `textInput`
* `timeInput`
* `urlInput`
* `weekInput`
* `loginInput`, a combination input consisting of a text input, password input,
  and a submit button
* `addressInput`, a combination input for specifying an address

### Outputs

* `badgeOutput`
* `streamOutput`
* `progressOutput`
* `sparklineOutput`

### Thruputs

* `tableThruput`, a reactive control which is used to render a table and turns
  the rendered table into an input allowing the user to select rows.
  
## Related packages and work

* https://github.com/rstudio/shiny
* https://github.com/Appsilon/shiny.semantic, based on the Semantic UI library
* https://github.com/daattali/shinyjs, javascript from the R side of shiny
* https://github.com/andrewsali/shinycssloaders, cool css loading animations
* https://github.com/cran/shinyFeedback, give user validation feedback (no repo, mirror only)

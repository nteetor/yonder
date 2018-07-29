# yonder

A reactive web framework built on [shiny](https://github.com/rstudio/shiny).

## Introduction

yonder is designed to make building pragmatic applications fun and rewarding. On
the UI side yonder features Font Awesome 5, aftertheflood's Spark font,
flatpickr calendar widgets, refreshed IonRange sliders, and Bootstrap 4. On the
server side yonder includes tools for showing alerts and toasts, displaying
modal and popovers, validating and freezing input values, and more!

## A first example

```R
library(yonder)

shinyApp(
  ui = container(
    h2("Iris k-means clustering"),
    row(
      column(
        width = 4,
        card(
          formGroup(
            "X variable",
            selectInput(
              id = "xcolumn",
              choices = names(iris)
            )
          ),
          formGroup(
            "Y variable",
            selectInput(
              id = "ycolumn",
              choices = names(iris),
              selected = names(iris)[2]
            )
          ),
          formGroup(
            "Cluster count",
            rangeInput(
              id = "clusters",
              min = 1,
              max = 9,
              default = 2,
              labels = 8,
              fill = FALSE
            ) %>%
              background("blue")
          )
        ) %>%
          background("grey")
      ),
      column(
        width = 8,
        plotOutput("plot1")
      )
    )
  ),
  server = function(input, output) {
    selected_data <- reactive({
      iris[ , c(input$xcolumn, input$ycolumn)]
    })

    clusters <- reactive({
      kmeans(selected_data(), as.numeric(input$clusters))
    })

    output$plot1 <- renderPlot({
      palette(
        c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999")
      )

      par(mar = c(5.1, 4.1, 0, 1))

      plot(selected_data(), col = clusters()$cluster, pch = 20, cex = 3)

      points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    })
  }
)
```

## Installation

yonder is still a work in progress and may be downloaded from GitHub.

```R
# install.packages("devtools")
devtools::install_github("nteetor/yonder")
```

## Related work

* https://github.com/rstudio/shiny, the big kahuna
* https://github.com/Appsilon/shiny.semantic, build shiny applications with the
  Semantic UI library
* https://github.com/daattali/shinyjs, use JavaScript calls and events from the
  R side of shiny
* https://github.com/andrewsali/shinycssloaders, improved CSS loading animations
  for shiny
* https://github.com/merlinoa/shinyFeedback, give users validation feedback
* https://github.com/ericrayanderson/shinymaterial, build shiny apps on top of material design

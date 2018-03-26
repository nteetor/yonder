# dull

Build Bootstrap 4 applications with the familiar Shiny toolkit.

## Introduction

dull is a set of UI and server functions . dull also features Font Awesome 5,
aftertheflood's Spark font, flatpickr calendar widgets, and refreshed IonRange
sliders.

## Check it out!

_(don't worry about `background()` or `padding()` for now)_

```R
library(dull)

sets <- as.data.frame(
  data(package = .packages(all.available = TRUE))$results,
  stringsAsFactors = FALSE
)

sets <- sets[!grepl(" ", sets$Item), ]
sets <- sets[with(sets, order(Item)), ]

shinyApp(
  ui = container(
    row(
      col(
        default = 2,
        h5("Data set"),
        selectInput(
          id = "dataset",
          choices = sets$Item,
          size = 16
        )
      ) %>%
        background("grey", +1) %>%
        border("grey") %>%
        padding(3),
      col(
        default = "auto",
        tableThruput("data", compact = TRUE) %>%
          height(75)
      ) %>%
        height(100),
      col(
        h5("Options"),
        radioInput(
          id = "format",
          choices = c(
            "csv",
            "tsv"
          )
        ),
        verbatimTextOutput("result")
      )
    ) %>%
      height(100)
  ) %>%
    height(100),
  server = function(input, output) {
    output$data <- renderTable({
      local({
        pkg <- sets[sets$Item == input$dataset, "Package"]
        expr <- sprintf("as.data.frame(%s::%s)", pkg, input$dataset)
        eval(parse(text = expr))
      })
    })

    output$result <- renderText({
      req(input$data)
      selected <- input$data
      collapse <- if (input$format == "csv") ", " else "\t"

      rows <- vapply(
        seq_len(NROW(selected)),
        function(i) paste0(selected[i, ], collapse = collapse),
        character(1)
      )

      rows <- c(paste0(colnames(selected), collapse = collapse), rows)

      paste0(rows, collapse = "\n")
    })
  }
)
```

## Installation

dull is still a work in progress and may be downloaded from GitHub.

```R
# install.packages("devtools")
devtools::install_github("nteetor/dull")
```

## Related work

* https://github.com/rstudio/shiny, the big kahuna
* https://github.com/Appsilon/shiny.semantic, build shiny applications with the
  Semantic UI library
* https://github.com/daattali/shinyjs, use JavaScript calls and events from the
  R side of shiny
* https://github.com/andrewsali/shinycssloaders, improved CSS loading animations
  for shiny
* https://github.com/cran/shinyFeedback, give users validation feedback (CRAN
  mirror only)
* https://ericrayanderson.github.io/shinymaterial/, build shiny apps on top of material design

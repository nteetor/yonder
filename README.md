# dull

A new approach to building Shiny applications. dull is not intended to replace 
shiny, dull builds upon shiny by providing updated versions of reactive inputs 
and outputs, includes new reactive inputs, and a third, new reactive control
thruputs, controls which are both inputs and outputs. dull is an exciting new
tool for those who have love working shiny.

## Introduction

dull is built on top of shiny's reactive engine, bootstrap 4, and FontAwesome 
(More and more libraries will be added to this list as dull grows!). The
package provides a new approach to many of the functionalities provided by
shiny. Because dull overwrites the Bootstrap 3 resources of shiny many new
replacement `*Input` functions are included as part of dull.

## Motivation

dull is an effort to provide the user more flexibility and open up new creative
possibilities for shiny based applications. Additionally, I believe shiny's
evolution has locked in paradigms that might otherwise not exist if the
developers could start with a clean slate. dull hopes to be that clean slate and
much of what I sought to build into dull I later found mirrored in the issues
and requests of the shiny GitHub repo.

## Installation

dull is still a work in progress and may be downloaded using
`devtools::install_github`.

```R
devtools::install_github("nteetor/dull")
```

## Example

```R
library(dull)  # will load shiny

shinyApp(
  ui = container(
    row(
      col(
        default = 4,
        tags$h5("Welcome to dull") %>% 
          padding(c(0, 0, 2, 0)) %>% 
          width(100) %>% 
          border("dark", "bottom"),
        intervalInput(
          id = "int", 
          default = c(25, 75)
        ),
        buttonInput(
          id = "go", 
          text = "GO!", 
          context = "primary",
          block = TRUE
        ) %>% 
          width(75)
      ) %>%
        padding(c(4, 3, 4, 3)) %>%
        background("light") %>%
        border("secondary"),
      col(

      )
    ) %>%
    margins(2)
  ),
  server = function(input, output) {
    observeEvent(input$go, {
      sendModal(
        title = "Whoops", 
        body = tags$div(
          "Sorry, this button does not doing anything yet."
        )
      )
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
* `formInput`, a new input which combines any number of _dull_ reactive inputs
  and includes a submit button which freezes only those inputs.
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

### Outputs

* `badgeOutput`
* `streamOutput`
* `progressOutput`

### Thruputs

* `tableThruput`, a reactive control which is used to render a table and turns
  the rendered table into an input allowing the user to select rows.

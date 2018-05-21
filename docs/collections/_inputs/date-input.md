---
layout: page
slug: date-input
roxygen:
  rdname: ~
  name: dateInput
  doctype: ~
  title: Date time input
  description: |-
    A date time picker. Alternatively, use the date time range picker to select
    a range of dates. The value of the date range picker is always two dates.
  parameters:
  - name: id
    description: A character specifying the id of the datetime input.
  - name: choices
    description: |-
      Date objects or character strings specifying the set of
      dates the user may choose from, defaults to `NULL` in which case the user
      may choose any date.
  - name: selected
    description: |-
      Date objects or character strings specifying the dates
      selected by default in the date input, defaults `NULL` in which case no
      dates are selected by default.
  - name: min,max
    description: |-
      Date objects or character strings in the format `YYYY-mm-dd`
      specifying the minimum and maximum date that can be selecetd, both
      default to `NULL` in which case there is no minimum or maximum value
      respectively.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE` specifying whether multiple dates
      may be selected, if `TRUE` the user may select multiple dates and a vector
      of one or more dates is returned as the reactive value.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              h6("Single date input:"),
              dateInput(
                id = "singledate"
              ),
              h6("Multiple dates input:") %>%
                margin(3, 0, 2, 0),
              dateInput(
                id = "multdate",
                choices = Sys.Date() + (-4:4),
                selected = Sys.Date() + 1,
                multiple = TRUE
              )
            ),
            column(
              verbatimTextOutput("values")
            )
          )
        ),
        server = function(input, output) {
          output$values <- renderPrint({
            list(
              single = input$singledate,
              multiple = input$multdate
            )
          })
        }
      )
    }
  aliases: ~
  family: inputs
  export: yes
  filename: datetime.R
  source: "dateInput <- function(id, choices = NULL, selected = NULL, min = NULL,
    \n    max = NULL, multiple = FALSE, ...) {\n    if (!is.null(choices)) {\n        if
    (!(is_date(choices) || is.character(choices)) && !all(is_ymd(choices))) {\n            stop(\"invalid
    `dateInput()` argument, `choices` must be date object(s) or \", \n                \"character
    string in the format YYYY-mm-dd\", \n                call. = FALSE)\n        }\n
    \   }\n    if (!is.null(selected)) {\n        if (!multiple && length(selected)
    > 1) {\n            stop(\"invalid `dateInput()` argument, if `multiple` is FALSE,
    `selected` \", \n                \"must be a single date object or character string\",
    \n                call. = FALSE)\n        }\n        if (!(is.character(selected)
    || is_date(selected)) && \n            !all(is_ymd(selected))) {\n            stop(\"invalid
    `dateInput()` argument, `selected` must be a date object \", \n                \"or
    character string in the format YYYY-mm-dd\", \n                call. = FALSE)\n
    \       }\n    }\n    if (!is.null(min) && !is_ymd(min)) {\n        stop(\"invalid
    `dateInput()` argument, `min` must be a date object or \", \n            \"character
    string in the format YYYY-mm-dd\", call. = FALSE)\n    }\n    if (!is.null(max)
    && !is_ymd(max)) {\n        stop(\"invalid `dateInput()` argument, `max` must
    be a date object or \", \n            \"character string in the format YYYY-mm-dd\",
    call. = FALSE)\n    }\n    if (!is.null(selected) && multiple) {\n        selected
    <- paste(vapply(selected, as.character, character(1)), \n            collapse
    = \"\\\\,\")\n    }\n    if (!is.null(choices)) {\n        choices <- paste(vapply(choices,
    as.character, character(1)), \n            collapse = \"\\\\,\")\n    }\n    shiny::registerInputHandler(\"dull.date\",
    dateHandler, TRUE)\n    tags$input(class = \"dull-date-input form-control\", id
    = id, \n        type = \"text\", `data-default-date` = selected, `data-enable`
    = choices, \n        `data-min-date` = min, `data-max-date` = max, `data-date-format`
    = \"Y-m-d\", \n        `data-mode` = if (multiple) \n            \"multiple\",
    ..., include(\"flatpickr\"))\n}"
---

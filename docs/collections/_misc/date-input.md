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
  - name: value
    description: |-
      The default value of the input, defaults to `NULL`, in which
      case the initial value is `NULL`.
  - name: min,max
    description: |-
      Date objects or character strings in the format `YYYY-mm-dd`
      specifying the minimum and maximum date that can be selecetd, both
      default to `NULL` in which case there is no minimum or maximum value
      respectively.
  - name: multiple
    description: |-
      `TRUE` or `FALSE` specifying whether multiple dates may be
      selected, if `TRUE` the user may select multiple dates and a vector of
      one or more dates is returned as the reactive value.
  sections: ~
  examples: "# date input ----\nif (interactive()) {\n  shinyApp(\n    ui = container(\n
    \     row(\n        col(\n          h6(\"Single date input:\"),\n          dateInput(\n
    \           id = \"datetime\"\n          ),\n          h6(\"Multiple dates input:\")
    %>%\n            margins(c(3, 0, 2, 0)),\n          dateInput(\n            id
    = \"datemult\",\n            value = Sys.Date() + 2:4, \n            multiple
    = TRUE\n          )\n        ),\n        col(\n          verbatimTextOutput(\"values\")\n
    \       )\n      )\n    ),\n    server = function(input, output) {\n      output$values
    <- renderPrint({\n        list(\n          single = input$datetime,\n          multiple
    = input$datemult\n        )\n      })\n    }\n  )\n}\n"
  aliases: ~
  family: ~
  export: yes
  filename: datetime.R
  source: "dateInput <- function(id, value = NULL, min = NULL, max = NULL, \n    multiple
    = FALSE) {\n    if (!is.null(value)) {\n        if (!multiple) {\n            if
    (length(value) > 1) {\n                stop(\"invalid `dateInput` argument, if
    `multiple` is FALSE, `value` must \", \n                  \"be a single date object
    or character string\", \n                  call. = FALSE)\n            }\n            if
    (!is.character(value) && !is_date(value)) {\n                stop(\"invalid `dateInput`
    argument, `value` must be a date object or \", \n                  \"character
    string in the format YYYY-mm-dd\", \n                  call. = FALSE)\n            }\n
    \           if (!is_ymd(value)) {\n                stop(\"invalid `dateInput`
    argument, `value` must be in the format YYYY-mm-dd\", \n                  call.
    = FALSE)\n            }\n        }\n        else {\n            passes <- function(x)
    (is.character(x) || is_date(x)) && \n                is_ymd(x)\n            if
    (!all(vapply(value, passes, logical(1)))) {\n                stop(\"invalid `dateInput`
    argument, `value` must be date \", \n                  \"objects and character
    strings in the format YYYY-mm-dd\", \n                  call. = FALSE)\n            }\n
    \       }\n    }\n    if (!is_ymd(min)) {\n        stop(\"invalid `dateRangeInput`
    argument, `min` must be a date object or \", \n            \"character string
    in the format YYYY-mm-dd\", call. = FALSE)\n    }\n    if (!is_ymd(max)) {\n        stop(\"invalid
    `dateRangeInput` argument, `max` must be a date object or \", \n            \"character
    string in the format YYYY-mm-dd\", call. = FALSE)\n    }\n    if (!is.null(value)
    && multiple) {\n        value <- paste(vapply(value, as.character, character(1)),
    \n            collapse = \"\\\\,\")\n    }\n    tags$div(class = \"dull-datetime-input\",
    id = id, tags$input(type = \"datetime-local\", \n        `data-default-date` =
    value, `data-alt-input` = \"true\", \n        `data-min-date` = min, `data-max-date`
    = max, `data-date-format` = \"Y-m-d\", \n        `data-mode` = if (multiple) \n
    \           \"multiple\"))\n}"
---

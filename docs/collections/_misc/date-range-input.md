---
layout: page
slug: date-range-input
roxygen:
  rdname: dateInput
  name: dateRangeInput
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: |
    # date range input ----
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              dateRangeInput(
                id = "daterange",
                value = c(Sys.Date(), Sys.Date() + 3)
              )
            ),
            col(
              verbatimTextOutput("values")
            )
          )
        ),
        server = function(input, output) {
          output$values <- renderPrint({
            input$daterange
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: datetime.R
  source: "dateRangeInput <- function(id, value = NULL, min = NULL, max = NULL) {\n
    \   if (!is.null(value)) {\n        if (length(value) != 2) {\n            stop(\"invalid
    `dateRangeInput` argument, `value` must be NULL or a pair of \", \n                \"date
    objects or character strings\", call. = FALSE)\n        }\n        passes <- function(x)
    (is.character(x) || is_date(x)) && \n            is_ymd(x)\n        if (!all(vapply(value,
    passes, logical(1)))) {\n            stop(\"invalid `dateRangeInput` argument,
    `value` must be date \", \n                \"objects and character strings in
    the format YYYY-mm-dd\", \n                call. = FALSE)\n        }\n    }\n
    \   if (!is_ymd(min)) {\n        stop(\"invalid `dateRangeInput` argument, `min`
    must be a date object or \", \n            \"character string in the format YYYY-mm-dd\",
    call. = FALSE)\n    }\n    if (!is_ymd(max)) {\n        stop(\"invalid `dateRangeInput`
    argument, `max` must be a date object or \", \n            \"character string
    in the format YYYY-mm-dd\", call. = FALSE)\n    }\n    if (!is.null(value)) {\n
    \       value <- paste(vapply(value, as.character, character(1)), \n            collapse
    = \"\\\\,\")\n    }\n    tags$div(class = \"dull-datetime-input\", id = id, tags$input(type
    = \"datetime-local\", \n        `data-default-date` = value, `data-alt-input`
    = \"true\", \n        `data-min-date` = min, `data-max-date` = max, `data-date-format`
    = \"Y-m-d\", \n        `data-mode` = \"range\"))\n}"
---

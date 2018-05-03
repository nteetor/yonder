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
  source:
  - dateRangeInput <- function(id, value = NULL, min = NULL, max = NULL) {
  - '  if (!is.null(value)) {'
  - '    if (length(value) != 2) {'
  - '      stop('
  - '        "invalid `dateRangeInput` argument, `value` must be NULL or a pair of
    ",'
  - '        "date objects or character strings", call. = FALSE'
  - '      )'
  - '    }'
  - '    passes <- function(x) (is.character(x) || is_date(x)) &&'
  - '        is_ymd(x)'
  - '    if (!all(vapply(value, passes, logical(1)))) {'
  - '      stop('
  - '        "invalid `dateRangeInput` argument, `value` must be date ",'
  - '        "objects and character strings in the format YYYY-mm-dd",'
  - '        call. = FALSE'
  - '      )'
  - '    }'
  - '  }'
  - '  if (!is_ymd(min)) {'
  - '    stop('
  - '      "invalid `dateRangeInput` argument, `min` must be a date object or ",'
  - '      "character string in the format YYYY-mm-dd", call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!is_ymd(max)) {'
  - '    stop('
  - '      "invalid `dateRangeInput` argument, `max` must be a date object or ",'
  - '      "character string in the format YYYY-mm-dd", call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!is.null(value)) {'
  - '    value <- paste('
  - '      vapply(value, as.character, character(1)),'
  - '      collapse = "\\,"'
  - '    )'
  - '  }'
  - '  tags$div(class = "dull-datetime-input", id = id, tags$input('
  - '    type = "datetime-local",'
  - '    `data-default-date` = value, `data-alt-input` = "true",'
  - '    `data-min-date` = min, `data-max-date` = max, `data-date-format` = "Y-m-d",'
  - '    `data-mode` = "range"'
  - '  ))'
  - '}'
---

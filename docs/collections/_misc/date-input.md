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
  source:
  - dateInput <- function(id, value = NULL, min = NULL, max = NULL,
  - '                      multiple = FALSE) {'
  - '  if (!is.null(value)) {'
  - '    if (!multiple) {'
  - '      if (length(value) > 1) {'
  - '        stop('
  - '          "invalid `dateInput` argument, if `multiple` is FALSE, `value` must
    ",'
  - '          "be a single date object or character string",'
  - '          call. = FALSE'
  - '        )'
  - '      }'
  - '      if (!is.character(value) && !is_date(value)) {'
  - '        stop('
  - '          "invalid `dateInput` argument, `value` must be a date object or ",'
  - '          "character string in the format YYYY-mm-dd",'
  - '          call. = FALSE'
  - '        )'
  - '      }'
  - '      if (!is_ymd(value)) {'
  - '        stop('
  - '          "invalid `dateInput` argument, `value` must be in the format YYYY-mm-dd",'
  - '          call. = FALSE'
  - '        )'
  - '      }'
  - '    }'
  - '    else {'
  - '      passes <- function(x) (is.character(x) || is_date(x)) &&'
  - '          is_ymd(x)'
  - '      if (!all(vapply(value, passes, logical(1)))) {'
  - '        stop('
  - '          "invalid `dateInput` argument, `value` must be date ",'
  - '          "objects and character strings in the format YYYY-mm-dd",'
  - '          call. = FALSE'
  - '        )'
  - '      }'
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
  - '  if (!is.null(value) && multiple) {'
  - '    value <- paste('
  - '      vapply(value, as.character, character(1)),'
  - '      collapse = "\\,"'
  - '    )'
  - '  }'
  - '  tags$div(class = "dull-datetime-input", id = id, tags$input('
  - '    type = "datetime-local",'
  - '    `data-default-date` = value, `data-alt-input` = "true",'
  - '    `data-min-date` = min, `data-max-date` = max, `data-date-format` = "Y-m-d",'
  - '    `data-mode` = if (multiple) {'
  - '      "multiple"'
  - '    }'
  - '  ))'
  - '}'
---

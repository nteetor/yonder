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
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              dateRangeInput(
                id = "daterange",
                selected = c(Sys.Date(), Sys.Date() + 3)
              )
            ),
            column(
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
  family: inputs
  export: yes
  filename: datetime.R
  source: "dateRangeInput <- function(id, choices = NULL, selected = NULL, \n    min
    = NULL, max = NULL, ...) {\n    if (!is.null(choices)) {\n        if (!(is.character(choices)
    || is_date(choices)) || !all(is_ymd(choices))) {\n            stop(\"invalid `dateRangeInput()`
    argument, `choices` must be date \", \n                \"object(s) and character
    string(s) in the format YYYY-mm-dd\", \n                call. = FALSE)\n        }\n
    \   }\n    if (!is.null(selected)) {\n        if (length(selected) != 2) {\n            stop(\"invalid
    `dateRangeInput()` argument, `selected` must be NULL or a pair of \", \n                \"date
    objects or character strings\", call. = FALSE)\n        }\n        if (!(is.character(selected)
    || is_date(selected)) || \n            !is_ymd(selected)) {\n            stop(\"invalid
    `dateRangeInput()` argument, `selected` must be date \", \n                \"object(s)
    and character string(s) in the format YYYY-mm-dd\", \n                call. =
    FALSE)\n        }\n    }\n    if (!is.null(min) && !is_ymd(min)) {\n        stop(\"invalid
    `dateRangeInput()` argument, `min` must be a date object or \", \n            \"character
    string in the format YYYY-mm-dd\", call. = FALSE)\n    }\n    if (!is.null(max)
    && !is_ymd(max)) {\n        stop(\"invalid `dateRangeInput()` argument, `max`
    must be a date object or \", \n            \"character string in the format YYYY-mm-dd\",
    call. = FALSE)\n    }\n    if (!is.null(selected)) {\n        selected <- paste(vapply(selected,
    as.character, character(1)), \n            collapse = \"\\\\,\")\n    }\n    if
    (!is.null(choices)) {\n        choices <- paste(vapply(choices, as.character,
    character(1)), \n            collapse = \"\\\\,\")\n    }\n    shiny::registerInputHandler(\"dull.date\",
    dateHandler, TRUE)\n    tags$input(class = \"dull-date-input form-control\", id
    = id, \n        type = \"text\", `data-default-date` = selected, `data-enable`
    = choices, \n        `data-min-date` = min, `data-max-date` = max, `data-date-format`
    = \"Y-m-d\", \n        `data-mode` = \"range\", ..., include(\"flatpickr\"))\n}"
---

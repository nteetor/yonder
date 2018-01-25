#' Date time input
#'
#' A date time picker. Alternatively, use the date time range picker to select
#' a range of dates. The value of the date range picker is always two dates.
#'
#' @param id A character specifying the id of the datetime input.
#'
#' @param value The default value of the input, defaults to `NULL`, in which
#'   case the initial value is `NULL`.
#'
#' @param min,max Date objects or character strings in the format `YYYY-mm-dd`
#'   specifying the minimum and maximum date that can be selecetd, both
#'   default to `NULL` in which case there is no minimum or maximum value
#'   respectively.
#'
#' @param multiple `TRUE` or `FALSE` specifying whether multiple dates may be
#'   selected, if `TRUE` the user may select multiple dates and a vector of
#'   one or more dates is returned as the reactive value.
#'
#' @export
#' @examples
#' # date input ----
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           h6("Single date input:"),
#'           dateInput(
#'             id = "datetime"
#'           ),
#'           h6("Multiple dates input:") %>%
#'             margins(c(3, 0, 2, 0)),
#'           dateInput(
#'             id = "datemult",
#'             multiple = TRUE
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("values")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$values <- renderPrint({
#'         list(
#'           single = input$datetime,
#'           multiple = input$datemult
#'         )
#'       })
#'     }
#'   )
#' }
#'
dateInput <- function(id, value = NULL, min = NULL, max = NULL,
                      multiple = FALSE) {
  if (!is.null(value)) {
    value <- as.character(value)

    if (is.na(strftime(value, format = "%Y-%m-%d"))) {
      stop(
        "invalid `dateInput` argument, `value` has unexpected format, ",
        "please use YYYY-mm-dd",
        call. = FALSE
      )
    }
  }

  tags$div(
    class = "dull-datetime-input",
    id = id,
    tags$input(
      type = "datetime-local",
      `data-default-date` = value,
      `data-alt-input` = "true",
      `data-min-date` = min,
      `data-max-date` = max,
      `data-date-format` = "Y-m-d",
      `data-mode` = if (multiple) "multiple"
    )
  )
}

#' @rdname dateInput
#' @export
#' @examples
#' # date range input ----
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           dateRangeInput(
#'             id = "daterange",
#'             value = c(Sys.Date(), Sys.Date() + 3)
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("values")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$values <- renderPrint({
#'         input$daterange
#'       })
#'     }
#'   )
#' }
#'
dateRangeInput <- function(id, value = NULL, min = NULL, max = NULL) {
  if (!is.null(value) && length(value) != 2) {
    stop(
      "invalid `dateRangeInput` argument, `value` must be NULL or a pair of ",
      "values",
      call. = FALSE
    )
  }

  tags$div(
    class = "dull-datetime-input",
    id = id,
    tags$input(
      type = "datetime-local",
      `data-default-date` = paste(value, collapse = "\\,"),
      `data-alt-input` = "true",
      `data-min-date` = min,
      `data-max-date` = max,
      `data-date-format` = "Y-m-d",
      `data-mode` = "range"
    )
  )
}

shiny::registerInputHandler(
  type = "dull.datetime",
  force = TRUE,
  function(x, session, name) {
    if (length(x) == 0) {
      return(NULL)
    }

    sort(strptime(unlist(x), format = "%Y-%m-%d"))
  }
)

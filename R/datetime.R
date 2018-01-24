#' Date time input
#'
#' A date time picker.
#'
#' @param id A character specifying the id of the datetime input.
#'
#' @param value The default value of the input, defaults to `NULL`, in which
#'   case the initial value is `NULL`.
#'
#' @param min,max Date objects or character strings in the format `YYY-mm-dd`
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
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           dateInput(
#'             id = "datetime",
#'             min = Sys.Date() + 10,
#'             multiple = TRUE
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderPrint({
#'         input$datetime
#'       })
#'     }
#'   )
#' }
dateInput <- function(id, value = NULL, placeholder = NULL, min = NULL,
                      max = NULL, multiple = FALSE) {
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

shiny::registerInputHandler(
  type = "dull.datetime",
  force = TRUE,
  function(x, session, name) {
    if (length(x) == 0) {
      return(NULL)
    }

    strptime(unlist(x), format = "%Y-%m-%d")
  }
)

# strptime(c("2018-01-01", "2019-01-01"), format = "%Y-%m-%d")

#' Select input
#'
#' Create a select input. Select elements often appear as a dropdown menu and
#' may have one or more selected values, see `multiple`.
#'
#' @param id A character string specifying the id of the select input.
#'
#' @param choices A character vector specifying the labels of the select input
#'   options.
#'
#' @param values A character vector specifying the values of the select input
#'   options, defaults to `chocies`.
#'
#' @param selected One of `values` indicating the default value of the select
#'   input, defaults to `NULL`. If `NULL` the first value is selected by
#'   default.
#'
#' @param multiple One of `TRUE` or `FALSE`, if `TRUE` multiple values may be
#'   selected, otherwise a single value is selected at a time,
#'   defaults to `FALSE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           selectInput(
#'             id = "select",
#'             choices = c("Choose one", "One", "Two", "Three"),
#'             values = list(NULL, 1, 2, 3),
#'             multiple = TRUE
#'           )
#'         ),
#'         column(
#'           d4(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderText({
#'         input$select
#'       })
#'     }
#'   )
#' }
#'
#'
selectInput <- function(id, choices, values = choices, selected = NULL,
                        multiple = FALSE, ...) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `selectInput` argument, `id` must be a character string or NULL",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `selectInput` arguments, `choices` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(selected)) {
    if (length(selected) > 1) {
      stop(
        "invalid `selectInput` argument, `selected` must be of length 1",
        call. = FALSE
      )
    }

    if (!(selected %in% values)) {
      stop(
        "invalid `selectInput` argument, `selected` must be one of `values`",
        call. = FALSE
      )
    }
  }

  selected <- match2(selected, values, default = TRUE)

  tags$div(
    class = "dull-select-input",
    id = id,
    tags$select(
      class = "custom-select",
      lapply(
        seq_along(choices),
        function(i) {
          tags$option(
            `data-value` = values[[i]],
            choices[[i]],
            selected = if (selected[[i]]) NA
          )
        }
      ),
      multiple = if (multiple) NA
    ),
    tags$div(class = "invalid-feedback"),
    ...,
    include("core")
  )
}

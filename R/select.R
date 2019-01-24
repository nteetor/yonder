#' Select input
#'
#' Create a select input. Select elements often appear as a dropdown menu and
#' may have one or more selected values, see `multiple`.
#'
#' @inheritParams buttonInput
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
#' @family inputs
#' @export
#' @examples
#'
#' ### Getting started
#'
#' selectInput(
#'   id = NULL,
#'   choices = c(
#'     "Choose one",
#'     "Choice 1",
#'     "Choice 2",
#'     "Choice 3"
#'   ),
#'   values = list(NULL, 1, 2, 3)
#' )
#'
selectInput <- function(id, choices, values = choices, selected = NULL,
                        multiple = FALSE, ...) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `selectInput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `selectInput()` arguments, `choices` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(selected)) {
    if (length(selected) > 1) {
      stop(
        "invalid `selectInput()` argument, `selected` must be of length 1",
        call. = FALSE
      )
    }

    if (!(selected %in% values)) {
      stop(
        "invalid `selectInput()` argument, `selected` must be one of `values`",
        call. = FALSE
      )
    }
  }

  selected <- match2(selected, values, default = TRUE)

  element <- tags$div(
    class = "yonder-select",
    id = id,
    tags$select(
      class = "custom-select",
      lapply(
        seq_along(choices),
        function(i) {
          tags$option(
            value = values[[i]],
            choices[[i]],
            selected = if (selected[[i]]) NA
          )
        }
      ),
      multiple = if (multiple) NA
    ),
    tags$div(class = "invalid-feedback"),
    ...
  )

  attachDependencies(
    element,
    yonderDep()
  )
}

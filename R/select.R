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
#'   selected, otherwise a single value is selected at a time, defaults to
#'   `FALSE`.
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
                        ..., multiple = FALSE) {
  assert_id()
  assert_choices()

  selected <- values %in% selected

  options <- map_options(choices, values, selected)

  component <- tags$div(
    class = "yonder-select",
    id = id,
    tags$select(
      class = "custom-select",
      multiple = if (multiple) NA,
      options
    ),
    tags$div(class = "invalid-feedback"),
    ...
  )

  attach_dependencies(component)
}

map_options <- function(choices, values, selected) {
  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$option(
        selected = if (select) NA,
        value = value,
        choice
      )
    }
  )
}

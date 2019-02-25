#' A chips input
#'
#' A selectize alternative.
#'
#' @inheritParams buttonInput
#'
#' @param choices A character vector or list specifying the possible choices.
#'
#' @param values A character vector or list of strings specifying the input's
#'   values, defaults to `choices`.
#'
#' @param selected One or more of `values` specifying which values are selected
#'   by default.
#'
#' @param max A number specifying the maximum number of items a user may select.
#'
#' @param fill One of `TRUE` or `FALSE` specifying the layout of chips. If
#'   `TRUE` chips fill the width of the parent element, otherwise if `FALSE` the
#'   chips are rendered inline, defaults to `TRUE`.
#'
#' @section **Example** simple application:
#'
#' ```R
#' ui <- container(
#'   chipInput(
#'     id = "chips",
#'     choices = paste("Option number", 1:10),
#'     values = 1:10,
#'     fill = TRUE
#'   ) %>%
#'     width("1/2")
#' )
#'
#' server <- function(input, output) {
#'
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @section **Example** inline chips:
#'
#' ```R
#' ui <- container(
#'   chipInput(
#'     id = "chips",
#'     choices = c(
#'       "A rather long option, isn't it?",
#'       "Shorter",
#'       "A middle-size option",
#'       "One more"
#'     ),
#'     values = 1:4,
#'     fill = FALSE
#'   ) %>%
#'     width("1/2") %>%
#'     background("blue") %>%
#'     shadow("small")
#' )
#'
#' server <- function(input, output) {
#'
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Default input
#'
#' chipInput(
#'   id = "chip1",
#'   choices = paste("Choice", 1:5)
#' )
#'
chipInput <- function(id, choices, values = choices, selected = NULL, ...,
                      max = NULL, fill = TRUE) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `chipInput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `chipInput()` argument, `choices` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  selected <- values %in% selected

  dropdownToggle <- tags$input(
    class = "form-control form-control-sm",
    `data-toggle` = "dropdown"
  )

  dropdownItems <- Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = collate(
          "dropdown-item",
          if (select) "selected"
        ),
        value = value,
        choice
      )
    }
  )

  chips <- Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = collate(
          "chip",
          if (select) "active"
        ),
        ## href = "javascript:void(0)",
        value = value,
        tags$span(
          class = "chip-content",
          choice
        ),
        tags$span(
          class = "chip-close",
          HTML("&times;")
        )
      )
    }
  )

  element <- div(
    id = id,
    class = collate(
      "yonder-chip",
      "btn-group dropup"
    ),
    `data-max` = max %||% -1,
    dropdownToggle,
    div(
      class = "dropdown-menu",
      dropdownItems
    ),
    div(
      class = collate(
        "chips",
        if (fill) "chips-block" else "chips-inline",
        "chips-grey"
      ),
      chips
    ),
    ...
  )

  attachDependencies(element, yonderDep())
}

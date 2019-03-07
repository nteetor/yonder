#' Radio inputs
#'
#' Create a reactive radio input of one or more radio controls.
#'
#' @inheritParams buttonInput
#'
#' @param choices A character vector specifying labels for the radio or radiobar
#'   input's choices.
#'
#' @param values A character vector, list of character strings, vector of values
#'   to coerce to character strings, or list of values to coerce to character
#'   strings specifying the values of the radio input's choices, defaults to
#'   `choices`.
#'
#' @param selected One of `values` indicating the default selected value of the
#'   radio input, defaults to `NULL`, in which case the first choice is
#'   selected by default.
#'
#' @param inline If `TRUE`, the radio input renders inline, defaults to `FALSE`,
#'   in which case the radio controls render on separate lines.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Out-of-the-box radios
#'
#' radioInput(
#'   id = "radio1",
#'   choices = c(
#'     "Vehicula adipiscing mattis",
#'     "Magna nullam",
#'     "Aenean venenatis",
#'     "Tristique quam porta"
#'   )
#' )
#'
#' ### Inline radio input
#'
#' radioInput(
#'   id = "radio2",
#'   choices = c(
#'     "Choice 1",
#'     "Choice 2",
#'     "Choice 3"
#'   ),
#'   inline = TRUE  # <-
#' )
#'
#' ### Radiobars in comparison
#'
#' radiobarInput(
#'   id = "radiobar1",
#'   choices = c(
#'     "fusce sagittis",
#'     "libero non molestie",
#'     "magna orci",
#'     "ultrices dolor"
#'   ),
#'   selected = "ultrices dolor"
#' ) %>%
#'   background("grey")
#'
radioInput <- function(id, choices, values = choices, selected = NULL, ...,
                       inline = FALSE) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `radioInput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `radioInput()` arguments, `choices` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  selected <- values %in% selected

  radios <- Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      child_id <- generate_id("radio")

      tags$div(
        class = collate(
          "custom-control",
          "custom-radio",
          if (inline) "custom-control-inline"
        ),
        tags$input(
          class = "custom-control-input",
          type = "radio",
          id = child_id,
          name = id,
          value = value,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        tags$label(
          class = "custom-control-label",
          `for` = child_id,
          choice
        )
      )
    }
  )

  input <- tags$div(
    class = "yonder-radio",
    id = id,
    radios,
    tags$div(class = "invalid-feedback")
  )

  attachDependencies(
    input,
    yonderDep()
  )
}

#' @rdname radioInput
#' @export
radiobarInput <- function(id, choices, values = choices, selected = NULL, ...) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `radiobarInput()` arguments, `choices` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- values %in% selected

  radios <- Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$label(
        class = collate(
          "btn",
          "btn-grey",
          if (select) "active"
        ),
        tags$input(
          name = id,
          type = "radio",
          value = value,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        choice
      )
    }
  )

  input <- tags$div(
    class = "yonder-radiobar btn-group btn-group-toggle d-flex",
    id = id,
    `data-toggle` = "buttons",
    ...,
    radios
  )

  attachDependencies(
    input,
    yonderDep()
  )
}

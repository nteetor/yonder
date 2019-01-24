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
#' @param disabled One or more of `values` indicating which radio choices to
#'   disable, defaults to `NULL`, in which case all choices are enabled.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Stacked radio input
#'
#' radioInput(
#'   id = "stacked",
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
#'   id = "inline",
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
#'   id = NULL,
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
                       disabled = NULL, inline = FALSE) {
  if (!is.null(selected) && !(selected %in% values)) {
    stop(
      "invalid `radioInput()` argument, `selected` must be one of `values`",
      call. = FALSE
    )
  }

  if (!is.null(disabled) && !(disabled %in% values)) {
    stop(
      "invalid `radioInput()` argument, `disabled` must be one of `values`",
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

  selected <- match2(selected, values, default = TRUE)
  disabled <- match2(disabled, values)
  ids <- ID(rep.int("radio", length(choices)))

  input <- tags$div(
    class = "yonder-radio",
    id = id,
    Map(
      choice = choices,
      value = values,
      select = selected,
      disable = disabled,
      .id = ids,
      function(choice, value, select, disable, .id) {
        tags$div(
          class = collate(
            "custom-control",
            "custom-radio",
            if (inline) "custom-control-inline"
          ),
          tags$input(
            class = "custom-control-input",
            type = "radio",
            id = .id,
            name = id,
            value = value,
            checked = if (select) NA,
            disabled = if (disable) NA
          ),
          tags$label(
            class = "custom-control-label",
            `for` = .id,
            choice
          )
        )
      }
    ),
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

  selected <- match2(selected, values)

  input <- tags$div(
    class = "yonder-radiobar btn-group btn-group-toggle",
    id = id,
    `data-toggle` = "buttons",
    ...,
    Map(
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
            autocomplete = "false",
            checked = if (select) NA
          ),
          choice
        )
      }
    )
  )

  attachDependencies(
    input,
    yonderDep()
  )
}

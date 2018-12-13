#' Radio inputs
#'
#' Create a reactive radio input of one or more radio controls.
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
#' @param help A character string specifying a small help label which appears
#'   below the input, defaults to `NULL` in which case help text is not added.
#'
#' @param inline If `TRUE`, the radio input renders inline, defaults to `FALSE`,
#'   in which case the radio controls render on separate lines.
#'
#' @param disabled One or more of `values` indicating which radio choices to
#'   disable, defaults to `NULL`, in which case all choices are enabled.
#'
#' @template input
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
radioInput <- function(id, choices, values = choices, selected = NULL,
                       disabled = NULL, help = NULL, inline = FALSE) {
  if (!is.null(selected) && !(selected %in% values)) {
    stop(
      "invalid `radioInput` argument, `selected` must be one of `values`",
      call. = FALSE
    )
  }

  if (!is.null(disabled) && !(disabled %in% values)) {
    stop(
      "invalid `radioInput` argument, `disabled` must be one of `values`",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `radioInput` arguments, `choices` and `values` must be the same ",
      "length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values, default = TRUE)
  disabled <- match2(disabled, values)
  ids <- ID(rep.int("radio", length(choices)))

  input <- tags$div(
    class = "yonder-radio",
    id = id,
    if (!is.null(choices)) {
      lapply(
        seq_along(choices),
        function(i) {
          tags$div(
            class = collate(
              "custom-control",
              "custom-radio",
              if (inline) "custom-control-inline"
            ),
            tags$input(
              class = "custom-control-input",
              type = "radio",
              id = ids[[i]],
              name = id,
              value = values[[i]],
              checked = if (selected[[i]]) NA,
              disabled = if (disabled[[i]]) NA
            ),
            tags$label(
              class = "custom-control-label",
              `for` = ids[[i]],
              choices[[i]]
            )
          )
        }
      )
    },
    tags$div(class = "invalid-feedback"),
    if (!is.null(help)) {
      tags$small(
        class = "form-text text-muted",
        help
      )
    }
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}

#' @rdname radioInput
#' @export
radiobarInput <- function(id, choices, values = choices, selected = NULL) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `radiobarInput` arguments, `choices` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  input <- tags$div(
    class = "yonder-radiobar btn-group btn-group-toggle",
    id = id,
    `data-toggle` = "buttons",
    lapply(
      seq_along(choices),
      function(i) {
        tags$label(
          class = collate(
            "btn",
            if (selected[[i]]) "active"
          ),
          tags$input(
            name = id,
            type = "radio",
            `data-value` = values[[i]],
            autocomplete = "false",
            checked = if (selected[[i]]) NA
          ),
          tags$span(
            choices[[i]]
          )
        )
      }
    )
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}

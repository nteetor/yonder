#' Checkbox inputs
#'
#' Reactive checkbox and checkbar inputs. Users may select one or more choices.
#' The checkbox input appears as a standard checkbox or set of checkboxes. The
#' checkbar input appears similar to a group of buttons, but with a checked or
#' highlighted state. When a checkbox or checkbar input has no selected choices
#' the reactive value is `NULL`.
#'
#' @param choices A character string or vector specifying a label for the
#'   checkbox or checkbar.
#'
#' @param values A character string or vector specifying values for the
#'   checkbox or checkbar input, defaults to `choice` or `values`, respectively.
#'
#' @param selected One or more of `values` specifying which choices are
#'   selected by default, defaults to `NULL`, in which case no choices are
#'   initially selected.
#'
#' @param inline One of `TRUE` or `FALSE` specifying if the checkbox input
#'   choices render inline or stacked, defaults to `FALSE`, in which case the
#'   choices are stacked.
#'
#' @template input
#' @export
#' @examples
#'
#' ### One option
#'
#' checkboxInput(
#'   id = "checkbox1",
#'   choices = "Choice 1",
#'   selected = "Choice 1"
#' )
#'
#' ### Multiple options
#'
#' checkboxInput(
#'   id = "checkbox2",
#'   choices = c("Choice 1", "Choice 2")
#' )
#'
#' ### Inline checkbox
#'
#' checkboxInput(
#'   id = "checkbox3",
#'   choices = c("Choice 1", "Choice 2", "Choice 3"),
#'   inline = TRUE
#' )
#'
#' ### Checkbar
#'
#' checkbarInput(
#'   id = "checks",
#'   choices = c(
#'     "Check 1",
#'     "Check 2",
#'     "Check 3"
#'   ),
#'   selected = "Check 1"
#' ) %>%
#'   background("blue") %>%
#'   margin(2)
#'
#' ### Labeling a checkbar
#'
#' formGroup(
#'   label = "Toppings",
#'   checkbarInput(
#'     id = "fixins",
#'     choices = c(
#'       "Sprinkles",
#'       "Nuts",
#'       "Fudge"
#'     )
#'   )
#' )
#'
checkboxInput <- function(id, choices, values = choices, selected = NULL, ...,
                          inline = FALSE) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `checkboxInput()` argument, `choices` and `values` must have ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  element <- tags$div(
    class = "yonder-checkbox",
    id = id,
    Map(
      choice = choices,
      value = values,
      select = selected,
      function(choice, value, select) {
        this <- ID("checkbox")

        tags$div(
          class = collate(
            "custom-control",
            "custom-checkbox",
            if (inline) "custom-control-inline"
          ),
          tags$input(
            class = "custom-control-input",
            type = "checkbox",
            id = this,
            name = id,
            value = value,
            checked = if (select) NA
          ),
          tags$label(
            class = "custom-control-label",
            `for` = this,
            choice
          ),
          tags$div(class = "invalid-feedback")
        )
      }
    ),
    ...
  )

  attachDependencies(
    element,
    yonderDep()
  )
}

#' @rdname checkboxInput
#' @export
checkbarInput <- function(id, choices, values = choices, selected = NULL, ...) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `checkbarInput()` arguments, `choices` and `values` must have ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  element <- tags$div(
    class = collate(
      "yonder-checkbar",
      if (length(choices) > 1) "btn-group",
      "btn-group-toggle"
    ),
    `data-toggle` = "buttons",
    id = id,
    lapply(
      seq_along(choices),
      function(i) {
        tags$label(
          class = collate(
            "btn",
            "btn-grey",
            if (selected[[i]]) "active"
          ),
          tags$input(
            type = "checkbox",
            autocomplete = "off",
            value = values[[i]],
            checked = if (selected[[i]]) NA
          ),
          choices[[i]]
        )
      }
    ),
    ...
  )

  attachDependencies(
    element,
    yonderDep()
  )
}

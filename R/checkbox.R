#' Checkbox inputs
#'
#' Reactive checkbox and checkbar inputs. Users may select one or more choices.
#' The checkbox input appears as a standard checkbox or set of checkboxes. The
#' checkbar input appears similar to a group of buttons, but with a checked or
#' highlighted state. When a checkbox or checkbar input has no selected choices
#' the reactive value is `NULL`. Switch inputs differ from checkboxes only in
#' appearance.
#'
#' @inheritParams buttonInput
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
#' @family inputs
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
#' ### Switches
#'
#' switchInput(
#'   id = "switch1",
#'   choices = paste("Switch choice", 1:3),
#'   selected = "Switch choice 3"
#' ) %>%
#'   active("indigo")
#'
checkboxInput <- function(id, choices, values = choices, selected = NULL, ...,
                          inline = FALSE) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `chekcboxInput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `checkboxInput()` argument, `choices` and `values` must have ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- values %in% selected

  checkboxes <- Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      child_id <- generate_id("checkbox")

      tags$div(
        class = collate(
          "custom-control",
          "custom-checkbox",
          if (inline) "custom-control-inline"
        ),
        tags$input(
          class = "custom-control-input",
          type = "checkbox",
          id = child_id,
          name = id,
          value = value,
          checked = if (select) NA
        ),
        tags$label(
          class = "custom-control-label",
          `for` = child_id,
          choice
        ),
        tags$div(class = "invalid-feedback")
      )
    }
  )

  element <- tags$div(
    class = "yonder-checkbox",
    id = id,
    checkboxes,
    ...
  )

  attachDependencies(element, yonderDep())
}

#' @rdname checkboxInput
#' @export
switchInput <- function(id, choices, values = choices, selected = NULL, ...) {
  input <- checkboxInput(id, choices, values, selected, inline = FALSE, ...)

  input[["children"]][[1]] <- lapply(input[["children"]][[1]], function(child) {
    tagAddClass(tagDropClass(child, "custom-checkbox"), "custom-switch")
  })

  input
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

  selected <- values %in% selected

  checkboxes <- Map(
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
          type = "checkbox",
          autocomplete = "off",
          value = value,
          checked = if (select) NA
        ),
        choice
      )
    }
  )

  element <- tags$div(
    class = "yonder-checkbar btn-group btn-group-toggle d-flex",
    id = id,
    `data-toggle` = "buttons",
    checkboxes,
    ...
  )

  attachDependencies(element, yonderDep())
}

#' Button and submit inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input begins as `NULL`, but subsequently is
#' the number of clicks.
#'
#' A submit input is a special type of button used to control form input
#' submission. Because of their specific usage, submit inputs do not require an
#' `id`, but may have a specified `value`. Submit inputs will _not_ freeze all
#' reactive inputs, see [formInput()].
#'
#' @template input
#'
#' @param label A character string specifying the label text on the button
#'   input.
#'
#' @param value A character string specifying the value of a submit input,
#'   defaults to `label`. This value is used to distinguish form submission
#'   types in the case where a form input has multiple submit inputs.
#'
#' @param block If `TRUE`, the input is block-level instead of inline, defaults
#'   to `FALSE`. A block-level element will occupy the entire width of its
#'   parent element.
#'
#' @param text A character string specifying the text displayed as part of the
#'   link input.
#'
#' @export
#' @examples
#' ### Simple vs block button
#'
#' buttonInput(
#'   id = NULL,
#'   label = "Simple"
#' )
#'
#' # Block buttons will fill the width of their parent element
#' buttonInput(
#'   id = NULL,
#'   label = "Block",
#'   block = TRUE
#' ) %>%
#'   background("red")
#'
#' ### A submit button
#'
#' submitInput()
#'
#' # Or use custom text to clarify the action taken when clicked by the user.
#'
#' submitInput("Place order")
#'
#' ### Possible colors
#'
#' colors <- c(
#'   "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'   "yellow", "amber", "orange", "grey"
#' )
#'
#' div(
#'   lapply(
#'     colors,
#'     function(color) {
#'       buttonInput(
#'         id = NULL,
#'         label = color
#'       ) %>%
#'         background(color) %>%
#'         margin(2)
#'     }
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
#' ### Reactive links
#'
#' div("Curabitur ", linkInput("inline", "vulputate"), " vestibulum lorem.")
#'
buttonInput <- function(id, label, ..., block = FALSE) {
  element <- tags$button(
    class = collate(
      "yonder-button",
      "btn",
      if (block) "btn-block",
      "btn-grey"
    ),
    type = "button",
    role = "button",
    id = id,
    label,
    ...
  )

  attachDependencies(
    element,
    yonderDep()
  )
}

#' @rdname buttonInput
#' @export
submitInput <- function(label = "Submit", value = label, block = FALSE, ...) {
  element <- tags$button(
    class = collate(
      "yonder-submit",
      "btn",
      "btn-blue",
      if (block) "btn-block"
    ),
    role = "button",
    value = value,
    label,
    ...
  )

  attachDependencies(
    element,
    yonderDep()
  )
}

#' @rdname buttonInput
#' @export
linkInput <- function(id, text, ...) {
  element <- tags$button(
    class = "yonder-link btn btn-link",
    id = id,
    text,
    ...
  )

  attachDependencies(
    element,
    yonderDep()
  )
}

#' Button group inputs
#'
#' A set of buttons with custom values.
#'
#' @param labels A character vector of labels, a button is added to the group
#'   for each label specified.
#'
#' @param values A character vector of values, one for each button specified,
#'   defaults to `labels`.
#'
#' @template input
#' @export
#' @examples
#'
#' ### Default input
#'
#' buttonGroupInput(
#'   id = NULL,
#'   labels = c("Once", "Twice", "Thrice"),
#'   values = c(1, 2, 3)
#' )
#'
#' ### Styling the button group
#'
#' buttonGroupInput(
#'   id = NULL,
#'   labels = c("Button 1", "Button 2", "Button 3")
#' ) %>%
#'   background("blue") %>%
#'   margin(3)
#'
buttonGroupInput <- function(id, labels, values = labels, ...) {
  if (length(labels) != length(values)) {
    stop(
      "invalid `buttonGroupInput()` arguments, `labels` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  shiny::registerInputHandler(
    type = "yonder.buttonGroup",
    fun = function(x, session, name) {
      if (length(x) > 1) x[[2]]
    },
    force = TRUE
  )

  element <- tags$div(
    class = "yonder-button-group btn-group",
    id = id,
    role = "group",
    Map(
      label = labels,
      value = values,
      function(label, value, outline) {
        tags$button(
          type = "button",
          class = "btn btn-grey",
          value = value,
          label
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

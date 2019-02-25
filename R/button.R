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
#' @param id A character string specifying the id of the reactive input.
#'
#' @param label A character string specifying the label text on the button
#'   input.
#'
#' @param value A character string specifying the value of a submit input,
#'   defaults to `label`. This value is used to distinguish form submission
#'   types in the case where a form input has multiple submit inputs.
#'
#' @param fill One of `TRUE` or `FALSE` specifying if the button fills the
#'   entire width of its parent, defaults to `FALSE`.
#'
#' @param text A character string specifying the text displayed as part of the
#'   link input.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#' ### A simple button
#'
#' buttonInput(
#'   id = "button1",
#'   label = "Simple"
#' )
#'
#' # Alternatively, a button can fill the width of its parent element.
#'
#' buttonInput(
#'   id = "button2",
#'   label = "Full-width",
#'   fill = TRUE  # <-
#' ) %>%
#'   background("red")
#'
#' # Use design utilities to further adjust the width of a button.
#'
#' buttonInput(
#'   id = "button3",
#'   label = "Full and back again",
#'   fill = TRUE  # <-
#' ) %>%
#'   background("red") %>%
#'   width("3/4")  # <-
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
#' lapply(
#'   colors,
#'   function(color) {
#'     buttonInput(
#'       id = color,
#'       label = color
#'     ) %>%
#'       background(color) %>%
#'       margin(2)
#'   }
#' ) %>%
#'   div() %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
#' ### Reactive links
#'
#' div("Curabitur ", linkInput("link1", "vulputate"), " vestibulum lorem.")
#'
buttonInput <- function(id, label, ..., fill = FALSE) {
  if (!is.null(id) && !is.character(label)) {
    stop(
      "invalid `buttonInput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  element <- tags$button(
    class = collate(
      "yonder-button",
      "btn",
      if (fill) "btn-block",
      "btn-grey"
    ),
    type = "button",
    role = "button",
    id = id,
    label,
    ...
  )

  attachDependencies(element, yonderDep())
}

#' @rdname buttonInput
#' @export
submitInput <- function(label = "Submit", value = label, ..., fill = FALSE) {
  element <- tags$button(
    class = collate(
      "yonder-submit",
      "btn",
      "btn-blue",
      if (fill) "btn-block"
    ),
    role = "button",
    value = value,
    label,
    ...
  )

  attachDependencies(element, yonderDep())
}

#' @rdname buttonInput
#' @export
linkInput <- function(id, text, ..., stretch = FALSE) {
  element <- tags$button(
    class = collate(
      "yonder-link",
      "btn btn-link",
      if (stretch) "stretched-link"
    ),
    id = id,
    text,
    ...
  )

  attachDependencies(element, yonderDep())
}

#' Button group inputs
#'
#' A set of buttons with custom values.
#'
#' @inheritParams buttonInput
#'
#' @param labels A character vector of labels, a button is added to the group
#'   for each label specified.
#'
#' @param values A character vector of values, one for each button specified,
#'   defaults to `labels`.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Default input
#'
#' buttonGroupInput(
#'   id = "group1",
#'   labels = c("Once", "Twice", "Thrice"),
#'   values = c(1, 2, 3)
#' )
#'
#' ### Styling the button group
#'
#' buttonGroupInput(
#'   id = "group2",
#'   labels = c("Button 1", "Button 2", "Button 3")
#' ) %>%
#'   background("blue") %>%
#'   width("1/3")
#'
buttonGroupInput <- function(id, labels, values = labels, ...) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `buttonGroupInput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

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

  buttons <- Map(
    label = labels,
    value = values,
    function(label, value) {
      tags$button(
        type = "button",
        class = "btn btn-grey",
        value = value,
        label
      )
    }
  )

  element <- tags$div(
    class = "yonder-button-group btn-group",
    id = id,
    role = "group",
    buttons,
    ...
  )

  attachDependencies(element, yonderDep())
}

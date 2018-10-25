#' Button and submit inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input is the number of times it has been
#' clicked.
#'
#' A submit input is a special type of button used to control HTML form
#' submission. Unlike shiny's `submitButton`, yonder's submit inputs will not
#' freeze all reactive inputs on the page.
#'
#' @param id A character string specifying the id of the button or link input.
#'
#' @param label A character string specifying the label text on the button
#'   input.
#'
#' @param block If `TRUE`, the input is block-level instead of inline, defaults
#'   to `FALSE`. A block-level element will occupy the entire width of its
#'   parent element.
#'
#' @param text A character string specifying the text displayed as part of the
#'   link input.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @details
#'
#' A submit input is automatically included as part of a [`formInput`].
#'
#' @family inputs
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
  shiny::registerInputHandler(
    type = "yonder.button",
    fun = function(x, session, name) as.numeric(x),
    force = TRUE
  )

  input <- tags$button(
    class = collate(
      "yonder-button",
      "btn",
      if (block) "btn-block",
      "btn-grey"
    ),
    type = "button",
    role = "button",
    label,
    id = id,
    ...
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}

#' @rdname buttonInput
#' @export
submitInput <- function(label = "Submit", block = FALSE, ...) {
  input <- tags$button(
    class = collate(
      "yonder-submit",
      "btn",
      "btn-blue",
      if (block) "btn-block"
    ),
    # done to avoid the way Shiny handles submit buttons, will be
    # moved to HTML attribute `type` once shiny app is connected
    `data-type` = "submit",
    role = "button",
    label,
    ...
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}

#' @rdname buttonInput
#' @export
linkInput <- function(id, text, ...) {
  shiny::registerInputHandler(
    type = "yonder.link",
    fun = function(x, session, name) {
      if (x$value == 0) {
        return(NULL)
      }

      id <- x$id
      attr(id, "clicks") <- x$value
      id
    },
    force = TRUE
  )

  input <- tags$span(
    class = "yonder-link",
    id = id,
    tags$u(text),
    ...
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}

#' Button group inputs
#'
#' A set of buttons with custom values.
#'
#' @param id A character string specifying the id of the button group input.
#'
#' @param labels A character vector of labels, a button is added to the group
#'   for each label specified.
#'
#' @param values A character vector of values, one for each button specified,
#'   defaults to `labels`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @family inputs
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

  input <- tags$div(
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
          `data-value` = value,
          label
        )
      }
    ),
    ...
  )

  attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )
}

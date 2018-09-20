#' Group inputs, combination button, dropdown, and text input
#'
#' A group input is a combination reactive input which may consist of one or two
#' buttons, dropdowns, static addons, or any combination of these elements.
#' Static addons, specified with `left` and `right` may be used to ensure an
#' group input's reactive value always has a certain prefix or suffix. These
#' static addons render with a shaded background to help indicated this behavior
#' to the user. Buttons and dropdowns may be included to control when the group
#' input's reactive value updates. See Details for more information.
#'
#' @param id A character string specifying the id of the group input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input group, defaults to `NULL`.
#'
#' @param value A character string specifying an initial value for the input
#'   group, defaults to `NULL`.
#'
#' @param left,right A character vector specifying static addons or
#'   [buttonInput()] or [dropdown()] elements specifying dynamic addons.
#'   Addon's affect the reactive value of the group input, see the Details
#'   section below for more information.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @section `left` and `right` combinations:
#'
#' **`left` is character or `right` is character**
#'
#' If `left` or `right` are character vectors, then the group input functions
#' like a text input. The value will update and trigger a reactive event when
#' the text box is modified. The group input's reactive value is the
#' concatention of the static addons specified by `left` or `right` and the
#' value of the text input.
#'
#' **`left` is button or `right` is button**
#'
#' The button does not change the value of the group input. However, the input
#' no longer triggers event when the text box is updated. Instead the value
#' is updated when a button is clicked. Static addons are still applied to the
#' group input value.
#'
#' **`left` is a dropdown or `right` is a dropdown**
#'
#' The value of the group input does chance depending on the clicked dropdown
#' menu item. The value of the input group is the concatentation of the
#' dropdown input value, the value of the text input, and any static addons.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Simple character string addon
#'
#' # This input will always append a "@@".
#'
#' groupInput(
#'   id = NULL,
#'   left = "@@",
#'   placeholder = "Username"
#' )
#'
#' ### Text input and button combo
#'
#' groupInput(
#'   id = NULL,
#'   placeholder = "Search terms",
#'   right = buttonInput(
#'     id = "button",
#'     label = "Go!"
#'   ) %>%
#'     border("transparent")
#' )
#'
#' ### Combination addon
#'
#' groupInput(
#'   id = NULL,
#'   left = c("$", "0.")
#' )
#'
#' ### Two addons
#'
#' groupInput(
#'   id = NULL,
#'   left = "@",
#'   placeholder = "Username",
#'   right = buttonInput(
#'     id = NULL,
#'     label = "Search"
#'   ) %>%
#'     background("transparent") %>%
#'     border("blue")
#' )
#'
groupInput <- function(id, placeholder = NULL, value = NULL, left = NULL,
                       right = NULL, ...) {
  if (!is.null(left) && !isValidAddon(left)) {
    stop(
      "invalid `groupInput()` argument, `left` must be a character string, ",
      "buttonInput(), or dropdown()",
      call. = FALSE
    )
  }

  if (!is.null(right) && !isValidAddon(right)) {
    stop(
      "invalid `groupInput()` argument, `right` must be a character string, ",
      "buttonInput(), or dropdown()",
      call. = FALSE
    )
  }

  shiny::registerInputHandler(
    type = "yonder.group",
    fun = function(x, session, name) paste0(x, collapse = ""),
    force = TRUE
  )

  input <- tags$div(
    class = "yonder-group input-group",
    id = id,
    if (!is.null(left)) {
      tags$div(
        class = "input-group-prepend",
        if (is.character(left)) {
          lapply(left, tags$span, class = "input-group-text")
        } else if (tagHasClass(left, "dropdown")) {
          left$children
        } else {
          # list of buttons
          left
        }
      )
    },
    tags$input(
      type = "text",
      class = "form-control",
      placeholder = placeholder,
      value = value
    ),
    if (!is.null(right)) {
      tags$div(
        class = "input-group-append",
        if (is.character(right)) {
          lapply(right, tags$span, class = "input-group-text")
        } else if (tagHasClass(right, "dropdown")) {
          right$children
        } else {
          # list of buttons
          right
        }
      )
    },
    ...
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}

isValidAddon <- function(tag) {
  if (all(class(tag) == "list")) {
    return(all(vapply(tag, tagIs, logical(1), "button")))
  }

  is.character(tag) ||
   tagIs(tag, "button") ||
   tagHasClass(tag, "dropdown")
}

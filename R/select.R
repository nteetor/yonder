#' Select inputs
#'
#' @description
#'
#' Create a select input. Select elements typically appear as a simple menu of
#' choices and may have one selected choice. A group select input is a select
#' input with one or two additional components. These addon components are used
#' to change the reactivity or value of the input, see Details for more
#' information.
#'
#' @inheritParams checkboxInput
#'
#' @param choices A character vector specifying the input's choices.
#'
#' @param values A character vector specifying the values of the input's
#'   choices, defaults to `choices`.
#'
#' @param selected One of `values` indicating the default value of the input,
#'   defaults to `values[[1]]`.
#'
#' @param placeholder A character string specifying the placeholder text of
#'   the select input, defaults to `NULL`.
#'
#' @param left,right A character vector specifying static addons or
#'   [buttonInput()] or [dropdown()] elements specifying dynamic addons. Addons
#'   affect the reactive value of the group input, see the Details section below
#'   for more information.
#'
#'   **`left` is character or `right` is character**
#'
#'   If `left` or `right` are character vectors, then the group input functions
#'   like a text input. The value will update and trigger a reactive event when
#'   the text box is modified. The group input's reactive value is the
#'   concatenation of the static addons specified by `left` or `right` and the
#'   value of the text input.
#'
#'   **`left` is button or `right` is button**
#'
#'   The button does not change the value of the group input. However, the input
#'   no longer triggers event when the text box is updated. Instead the value is
#'   updated when a button is clicked. Static addons are still applied to the
#'   group input value.
#'
#'   **`left` is a dropdown or `right` is a dropdown**
#'
#'   The value of the group input does chance depending on the clicked dropdown
#'   menu item. The value of the input group is the concatenation of the
#'   dropdown input value, the value of the text input, and any static addons.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Simple select input
#'
#' selectInput(
#'   id = "select1",
#'   choices = c(
#'     "Choice 1",
#'     "Choice 2",
#'     "Choice 3"
#'   ),
#'   values = list(1, 2, 3)
#' )
#'
#' ### Group select input
#'
#' groupSelectInput(
#'   id = "select2",
#'   choices = 1:5,
#'   left = "$",
#'   right = ".00"
#' ) %>%
#'   width(10)
#'
selectInput <- function(id, choices = NULL, values = choices,
                        selected = values[[1]], ..., placeholder = NULL) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)

  dep_attach({
    items <- map_selectitems(choices, values, selected)

    tags$div(
      class = "yonder-select",
      id = id,
      tags$input(
        type = "text",
        class = "form-control custom-select",
        `data-toggle` = "dropdown",
        `data-boundary` = "window",
        placeholder = choices[values %in% selected][1] %||% placeholder,
        `data-original-placeholder` = placeholder
      ),
      tags$div(
        class = "dropdown-menu",
        items
      ),
      tags$div(class = "valid-feedback"),
      tags$div(class = "invalid-feedback"),
      ...
    )
  })
}

#' @rdname selectInput
#' @export
updateSelectInput <- function(id, choices = NULL, values = choices,
                              selected = choices[[1]], enable = NULL,
                              disable = NULL,
                              valid = NULL, invalid = NULL,
                              session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)
  assert_session()

  options <- map_selectitems(choices, values, selected)

  content <- coerce_content(options)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)
  valid <- coerce_valid(valid)
  invalid <- coerce_invalid(invalid)

  session$sendInputMessage(id, list(
    content = content,
    selected = selected,
    enable = enable,
    disable = disable,
    valid = valid,
    invalid = invalid
  ))
}

map_selectitems <- function(choices, values, selected) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = str_collate(
          "dropdown-item",
          if (select) "active"
        ),
        value = value,
        choice
      )
    }
  )
}

#' @rdname selectInput
#' @export
groupSelectInput <- function(id, choices, values = choices,
                             selected = values[[1]], ..., left = NULL,
                             right = NULL) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)
  assert_left()
  assert_right()

  shiny::registerInputHandler(
    type = "yonder.group.select",
    fun = function(x, session, name) paste0(x, collapse = ""),
    force = TRUE
  )

  dep_attach({
    options <- map_options(choices, values, selected)
    left <- addon_left(left)
    right <- addon_right(right)

    tags$div(
      class = "yonder-group-select input-group",
      id = id,
      left,
      tags$select(
        class = "custom-select",
        options
      ),
      right,
      tags$div(class = "valid-feedback"),
      tags$div(class = "invalid-feedback"),
      ...
    )
  })
}

#' @rdname selectInput
#' @export
updateGroupSelectInput <- function(id, choices = NULL, values = choices,
                                   selected = NULL, enable = NULL,
                                   disable = NULL, valid = NULL,
                                   invalid = NULL,
                                   session = getDefaultReactiveDomain()) {
  assert_id()
  assert_choices()
  assert_selected(length = 1)
  assert_session()

  options <- map_options(choices, values, selected)

  content <- coerce_content(options)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)
  valid <- coerce_valid(valid)
  invalid <- coerce_invalid(invalid)

  session$sendInputMessage(id, list(
    content = content,
    selected = selected,
    enable = enable,
    disable = disable,
    valid = valid,
    invalid = invalid
  ))
}

map_options <- function(choices, values, selected) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$option(
        selected = if (select) NA,
        value = value,
        choice
      )
    }
  )
}

addon_left <- function(left) {
  if (!is.null(left)) {
    tags$div(
      class = "input-group-prepend",
      if (is.character(left)) {
        lapply(left, tags$span, class = "input-group-text")
      } else if (tag_class_re(left, "dropdown")) {
        left$children
      } else {
        # list of buttons
        left
      }
    )
  }
}

addon_right <- function(right) {
  if (!is.null(right)) {
    tags$div(
      class = "input-group-append",
      if (is.character(right)) {
        lapply(right, tags$span, class = "input-group-text")
      } else if (tag_class_re(right, "dropdown")) {
        right$children
      } else {
        # list of buttons
        right
      }
    )
  }
}

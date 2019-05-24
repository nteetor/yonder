possible_types <- c(
  "color",
  "date",
  "datetime-local",
  "email",
  "month",
  "number",
  "password",
  "search",
  "tel",
  "text",
  "time",
  "url",
  "week"
)

param_type <- function() {
  q_start <- '"`'
  q_end <- '`"'

  paste(
    "@param type One of",
    paste(q_start, utils::head(possible_types, -1), q_end, collapse = ", "),
    "or",
    paste(q_start, utils::tail(possible_types, 1), q_end),
    'specifying the type of text input, defaults to `"text"`.',
    "\n\n",
    "For details on a particular type please see",
    "\\url{https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input}."
  )
}

#' Text inputs
#'
#' @description
#'
#' A text input. A group text input is an alternative text input. The group text
#' input allows you to include static prefixes or buttons with a standard text
#' input.
#'
#' `numberInput()` is a simple wrapper around `textInput()` with `type` set to
#' `"number"` and explicit arguments for specifying a min value, max value, and
#' the step amount. Use `updateTextInput()` to update a number input.
#'
#' @inheritParams checkboxInput
#'
#' @inheritParams selectInput
#'
#' @param value A character string or a value coerced to a character string
#'   specifying the default value of the textual input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input, defaults to `NULL`, in which case there is no placeholder text.
#'
#' @eval param_type()
#'
#' @param min A number specifying the minimum allowed value of the number input,
#'   defaults to `NULL`.
#'
#' @param max A number specifying the maximum allowed value of the number input,
#'   defaults to `NULL`.
#'
#' @param step A number specifying the increment step of the number input,
#'   defaults to 1.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Default text input
#'
#' textInput(id = "text")
#'
#' ### Default number input
#'
#' numberInput(id = "num1")
#'
#' ### Specify `min`, `max`, and `step`
#'
#' numberInput(
#'   id = "num2",
#'   min = 1,
#'   max = 10,
#'   step = 2
#' )
#'
textInput <- function(id, value = NULL, placeholder = NULL, ...,
                      type = "text") {
  assert_id()
  assert_possible(type, possible_types)

  component <- tags$div(
    class = "yonder-textual",
    id = id,
    tags$input(
      class = "form-control",
      type = type,
      value = value,
      placeholder = placeholder,
      autocomplete = "off"
    ),
    tags$div(class = "valid-feedback"),
    tags$div(class = "invalid-feedback"),
    ...
  )

  attach_dependencies(component)
}

#' @rdname textInput
#' @export
numberInput <- function(id, value = NULL, placeholder = NULL, ..., min = NULL,
                        max = NULL, step = 1) {
  assert_id()

  component <- textInput(
    id = id, value = value, placeholder = placeholder, ...,
    type = "number"
  )

  component$children[[1]] <- tag_attributes_add(
    component$children[[1]],
    drop_nulls(list(min = min, max = max, step = step))
  )

  component
}


#' @rdname textInput
#' @export
updateTextInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                            valid = NULL, invalid = NULL,
                            session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  enable <- coerce_enable(valid)
  disable <- coerce_disable(valid)
  valid <- coerce_valid(valid)
  invalid <- coerce_invalid(invalid)

  session$sendInputMessage(id, list(
    value = value,
    enable = enable,
    disable = disable,
    valid = valid,
    invalid = invalid
  ))
}

#' @rdname textInput
#' @export
groupTextInput <- function(id, value = NULL, placeholder = NULL, ...,
                           type = "text", left = NULL, right = NULL) {
  assert_id()
  assert_possible(type, possible_types)
  assert_left()
  assert_right()

  shiny::registerInputHandler(
    type = "yonder.group.text",
    fun = function(x, session, name) paste0(x, collapse = ""),
    force = TRUE
  )

  left <- addon_left(left)
  right <- addon_right(right)

  component <- tags$div(
    class = "yonder-group-text input-group",
    id = id,
    left,
    tags$input(
      type = type,
      class = "form-control",
      placeholder = placeholder,
      value = value,
      autocomplete = "off"
    ),
    right,
    tags$div(class = "valid-feedback"),
    tags$div(class = "invalid-feedback"),
    ...
  )

  attach_dependencies(component)
}

#' @rdname textInput
#' @export
updateGroupTextInput <- function(id, value = NULL,
                                 enable = NULL, disable = NULL, valid = NULL,
                                 invalid = NULL,
                                 session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)
  valid <- coerce_valid(valid)
  invalid <- coerce_invalid(invalid)

  session$sendInputMessage(id, list(
    value = value,
    enable = enable,
    disable = disable,
    valid = valid,
    invalid = invalid
  ))
}

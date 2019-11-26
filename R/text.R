possible_types <- c(
  "color",
  "date",
  "datetime-local",
  "email",
  "month",
  "password",
  "search",
  "tel",
  "text",
  "time",
  "url",
  "week"
)

roxy_param_type <- function() {
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
#' @eval roxy_param_type()
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Default text input
#'
#' textInput(id = "text")
#'
textInput <- function(id, value = NULL, placeholder = NULL, ...,
                      type = "text") {
  assert_id()
  assert_possible(type, possible_types)

  dep_attach({
    tags$div(
      class = "yonder-text",
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
  })
}

#' @rdname textInput
#' @export
updateTextInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                            valid = NULL, invalid = NULL,
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

  dep_attach({
    left <- addon_left(left)
    right <- addon_right(right)

    tags$div(
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
  })
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

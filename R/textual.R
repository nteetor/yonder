#' Textual inputs
#'
#' Different types of textual inputs are provided to best support mobile
#' keyboards and assistive technologies. A password input will mask its
#' contents. Email inputs offer client-side validation depending on the browser.
#'
#' @inheritParams buttonInput
#'
#' @param value A character string or a value coerced to a character string
#'   specifying the default value of the textual input.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input, defaults to `NULL`, in which case there is no placeholder text.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Basic text
#'
#' textInput(id = "text")
#'
#' ### Search
#'
#' searchInput(id = "search")
#'
#' ### Email
#'
#' emailInput(id = "email")
#'
#' ### URLs
#'
#' urlInput(id = "url")
#'
#' ### Telephone numbers
#'
#' telephoneInput(id = "tele")
#'
#' ### Passwords
#'
#' passwordInput(id = "password")
#'
#' ### Numbers
#'
#' numberInput(id = "num")
#'
textInput <- function(id, value = NULL, placeholder = NULL, ...) {
  assert_id()

  textualInput(id, value, placeholder, ..., type = "text")
}

#' @rdname textInput
#' @export
updateTextInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                            valid = NULL, invalid = NULL,
                            session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  updateTextualInput(id, value, enable, disable, valid, invalid, session)
}

#' @rdname textInput
#' @export
searchInput <- function(id, value = NULL, placeholder = NULL, ...) {
  assert_id()

  textualInput(id, value, placeholder, ..., type = "search")
}

#' @rdname textInput
#' @export
updateSearchInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                              valid = NULL, invalid = NULL,
                              session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  updateTextualInput(id, value, enable, disable, valid, invalid, session)
}

#' @rdname textInput
#' @export
emailInput <- function(id, value = NULL, placeholder = NULL, ...) {
  assert_id()

  textualInput(id, value, placeholder, ..., type = "email")
}

#' @rdname textInput
#' @export
updateEmailInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                             valid = NULL, invalid = NULL,
                             session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  updateTextualInput(id, value, enable, disable, valid, invalid, session)
}

#' @rdname textInput
#' @export
urlInput <- function(id, value = NULL, placeholder = NULL, ...) {
  assert_id()

  textualInput(id, value, placeholder, ..., type = "url")
}

#' @rdname textInput
#' @export
updateUrlInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                           valid = NULL, invalid = NULL,
                           session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  updateTextualInput(id, value, enable, disable, valid, invalid, session)
}

#' @rdname textInput
#' @export
telephoneInput <- function(id, value = NULL, placeholder = NULL, ...) {
  assert_id()

  textualInput(id, value, placeholder, ..., type = "tel")
}

#' @rdname textInput
#' @export
updateTelephoneInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                                 valid = NULL, invalid = NULL,
                                 session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  updateTextualInput(id, value, enable, disable, valid, invalid, session)
}

#' @rdname textInput
#' @export
passwordInput <- function(id, value = NULL, placeholder = NULL, ...) {
  assert_id()

  textualInput(id, value, placeholder, ..., type = "password")
}

#' @rdname textInput
#' @export
updatePassowrdInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                                valid = NULL, invalid = NULL,
                                session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  updateTextualInput(id, value, enable, disable, valid, invalid, session)
}

#' @rdname textInput
#' @export
numberInput <- function(id, value = NULL, placeholder = NULL, ...) {
  assert_id()

  textualInput(id, value, placeholder, ..., type = "number")
}

#' @rdname textInput
#' @export
updateNumberInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                              valid = NULL, invalid = NULL,
                              session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  if (!is.null(value) && !is.numeric(value)) {
    stop(
      "invalid argument in `updateNumberInput()`, argument `valid` must be ",
      "numeric or NULL",
      call. = FALSE
    )
  }

  updateTextualInput(id, value, enable, disable, valid, invalid, session)
}

textualInput <- function(id, value, placeholder, ..., type,
                         autocomplete = FALSE) {
  component <- tags$div(
    class = "yonder-textual",
    id = id,
    tags$input(
      class = "form-control",
      type = type,
      value = value,
      placeholder = placeholder,
      autocomplete = if (autocomplete) "on" else "off"
    ),
    tags$div(class = "valid-feedback"),
    tags$div(class = "invalid-feedback"),
    ...
  )

  attach_dependencies(component)
}


updateTextualInput <- function(id, value, enable, disable, valid, invalid,
                               session) {
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

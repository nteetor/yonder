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
  textualInput(id, value, placeholder, ..., type = "text")
}

#' @rdname textInput
#' @export
searchInput <- function(id, value = NULL, placeholder = NULL, ...) {
  textualInput(id, value, placeholder, ..., type = "search")
}

#' @rdname textInput
#' @export
emailInput <- function(id, value = NULL, placeholder = NULL, ...) {
  textualInput(id, value, placeholder, ..., type = "email")
}

#' @rdname textInput
#' @export
urlInput <- function(id, value = NULL, placeholder = NULL, ...) {
  textualInput(id, value, placeholder, ..., type = "url")
}

#' @rdname textInput
#' @export
telephoneInput <- function(id, value = NULL, placeholder = NULL, ...) {
  textualInput(id, value, placeholder, ..., type = "tel")
}

#' @rdname textInput
#' @export
passwordInput <- function(id, value = NULL, placeholder = NULL, ...) {
  textualInput(id, value, placeholder, ..., type = "password")
}

#' @rdname textInput
#' @export
numberInput <- function(id, value = NULL, placeholder = NULL, ...) {
  textualInput(id, value, placeholder, ..., type = "number")
}

textualInput <- function(id, value, placeholder, ..., type,
                         autocomplete = FALSE) {
  attachDependencies(
    tags$div(
      class = "yonder-textual",
      id = id,
      tags$input(
        class = "form-control",
        type = type,
        value = value,
        placeholder = placeholder,
        autocomplete = if (autocomplete) "on" else "off"
      ),
      tags$div(class = "invalid-feedback"),
      ...
    ),
    yonderDep()
  )
}

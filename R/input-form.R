#' Form inputs
#'
#' @description
#'
#' Form inputs are a new reactive input. Form inputs are an alternative to
#' shiny's submit buttons. A form input is comprised of any number of inputs.
#' The value of these inputs will _not_ change until a form submit button within
#' the form input is clicked. A form input's reactive value depends on the
#' clicked form submit button. This allows you to distinguish between different
#' form submission types, think "login" versus "register".
#'
#' A form submit button, `formSubmit()`, is a special type of button used to
#' control form input submission. A form input and its child reactive inputs
#' will _never_ update if a form submit button is not included in `...` passed
#' to `formInput()`.
#'
#' @inheritParams checkboxInput
#'
#' @param ... Any number of unnamed arguments passed as child elements to the
#'   parent form element or named arguments passed as HTML attributes to the
#'   parent element. At least one `formSubmit()` must be included.
#'
#' @param inline One of `TRUE` or `FALSE`, if `TRUE` the form and its child
#'   elements are rendered in a horizontal row, defaults to `FALSE`. On small
#'   viewports, think mobile device, `inline` intentionally has no effect and
#'   the form will span multiple lines.
#'
#' @param label A character string specifying the label of the form submit
#'   button.
#'
#' @param value A character string specifying the value of the form submit
#'   button and the value of the form input when the button is clicked,
#'   defaults to `label`.
#'
#' @param submit One of `TRUE` or `FALSE` or a character string specifying
#'   whether to trigger a form submission, defaults to `FALSE`. If a character
#'   string, the form is submitted and the reactive value passed is the character
#'   string specified.
#'
#' @includeRmd man/roxygen/form.Rmd
#'
#' @family inputs
#' @export
formInput <- function(..., id, inline = FALSE) {
  assert_id()

  dep_attach({
    tags$form(
      class = str_collate(
        "yonder-form",
        if (inline) "form-inline"
      ),
      id = id,
      ...
    )
  })
}

#' @rdname formInput
#' @export
formSubmit <- function(label, value = label, ...) {
  dep_attach({
    tags$button(
      class = "yonder-form-submit btn btn-blue",
      value = value,
      label,
      ...
    )
  })
}

#' @rdname formInput
#' @export
updateFormInput <- function(id, submit = FALSE,
                            session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  if (!(is.logical(submit) || is.character(submit)) ||
        (is.character(submit) && length(submit) > 1)) {
    stop(
      "invalid argument in `updateFormInput()`, `submit` must be one of ",
      "TRUE or FALSE or a character string",
      call. = FALSE
    )
  }

  submit <- coerce_submit(submit)

  session$sendInputMessage(id, list(
    submit = submit
  ))
}

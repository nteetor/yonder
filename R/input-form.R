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
#' @inheritParams input_checkbox
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
#' @family inputs
#' @export
input_form <- function(
  id,
  ...,
  label = NULL,
  disable = FALSE,
  inline = FALSE
) {
  check_string(id, allow_empty = FALSE)
  check_string(label, allow_null = TRUE)

  args <- list(...)
  attrs <- keep_named(args)
  children <- keep_unnamed(args)

  input <-
    tags$form(
      class = c(
        "bsides-form",
        if (inline) "form-inline"
      ),
      id = id,
      !!!attrs,
      tags$fieldset(
        disabled = if (isTRUE(disable)) NA,
        if (non_null(label)) {
          tags$legend(label)
        },
        !!!children
      )
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, "bsides_form_input")

  input
}

#' @rdname input_form
#' @export
form_submit_button <- function(
  label,
  value = label,
  ...
) {
  tags$button(
    class = "bsides-btn-submit btn btn-primary",
    value = value,
    label,
    ...
  )
}

#' @rdname input_form
#' @export
submit_form <- function(
  id,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)

  msg <-
    list(
      submit = TRUE
    )

  session$sendInputMessage(id, msg)
}

#' Form inputs
#'
#' @description
#'
#' Form inputs are a new reactive input. Form inputs are an alternative to
#' [shiny::submitButton]. A form input is comprised of any number of inputs. The
#' values of these inputs do not reactively update. The inputs will reactively
#' update when a form submit button is clicked.
#'
#' A form input's reactive value depends on the clicked form submit button. This
#' allows server logic to distinguish between different form submission types,
#' think "login" versus "register".
#'
#' @inheritParams input_checkbox_group
#'
#' @param ... Reactive inputs.
#'
#' @param label A character string. The label of the input.
#'
#' @param value A character string. The input's value when the submit button is
#'   clicked.
#'
#' @param layout <[responsive]> A character string.
#'
#' @param gap A number. The space between inputs, `0` through `5`.
#'
#' @family inputs
#' @export
input_form <- function(
  id,
  ...,
  label = NULL,
  layout = NULL
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
  ...,
  value = label
) {
  button <-
    tags$button(
      class = "bsides-btn-submit btn btn-primary",
      value = value,
      label,
      ...
    )

  button <-
    s3_class_add(button, "bsides_form_submit_button")

  button
}

#' @rdname input_form
#' @export
update_form <- function(
  id,
  label = NULL,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)
  check_string(label, allow_null = TRUE)

  msg <-
    list(
      label = label
    )

  session$sendInputMessage(id, msg)
}

#' @rdname input_form
#' @export
submit_form <- function(
  id,
  value,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)
  check_string(value)

  msg <-
    list(
      submit = value
    )

  session$sendInputMessage(id, msg)
}

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
#' @details
#'
#' ## Submits that wait
#'
#' Usually a submit is immediate: the held values are released and the
#' form's own value is set, in that order, as the button is clicked.
#'
#' A nested input may have work that must finish first, though — an
#' [input_file()] with `upload_mode = "manual"` uploads its staged files
#' at this point, and its value arrives when that upload ends rather than
#' when the button is clicked, so it is not among the values the form is
#' holding. The submit then waits for it. Every submit button in the form
#' is disabled and the clicked one shows a pending state, so a form that
#' is waiting does not read as a form that is broken. The values go once
#' the work finishes, which is what lets an observer keyed on the submit
#' read the uploaded files.
#'
#' If that work fails, or the user cancels it, nothing is sent at all.
#' The held values stay held, so submitting again retries with
#' everything intact.
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
#' @param layout A character string.
#'
#' @family inputs
#' @export
input_form <-
  function(
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
          "bsides-input-form"
          # if (inline) "form-inline"
        ),
        id = id,
        !!!attrs,
        tags$fieldset(
          # disabled = if (isTRUE(disable)) NA,
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
form_submit_button <-
  function(
    label,
    ...,
    value = label
  ) {
    button <-
      tags$button(
        class = "bsides-input-form-submit btn btn-primary",
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
update_form <-
  function(
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
submit_form <-
  function(
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

#' Button and link inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input begins as `NULL`, but subsequently is
#' the number of clicks.
#'
#' @param id A character string. specifying the id of the reactive input.
#'
#' @param label A character string specifying the label text on the button or
#'   link input.
#'
#' @param icon An icon, see [bsicons::bs_icon].
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
input_button <- function(
  id,
  label,
  ...
) {
  assert_id()
  assert_label()

  tag <-
    tags$button(
      class = "bsides-button btn btn-primary",
      type = "button",
      role = "button",
      id = id,
      label,
      ...
    )

  tag <-
    dependency_append(tag)

  tag
}

#' @rdname input_button
#' @export
update_button <- function(
  id,
  label = NULL,
  value = NULL,
  disable = NULL,
  session = get_current_session()
) {
  assert_id()
  assert_session()

  stopifnot(
    is.null(value) || is.numeric(value)
  )

  content <- coerce_content(label)
  disable <- coerce_disable(disable)

  session$sendInputMessage(
    id,
    drop_nulls(list(
      content = content,
      value = value,
      disable = disable
    ))
  )
}

button_input_type <- "bsides.button"

button_input_register_handler <- function() {
  shiny::registerInputHandler(
    button_input_type,
    function(
      value,
      session,
      name
    ) {
      if (identical(value, 0L)) {
        return(NULL)
      }

      value
    },
    force = TRUE
  )
}

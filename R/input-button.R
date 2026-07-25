#' Button inputs
#'
#' @description
#'
#' Button inputs are useful as triggers for reactive or observer expressions.
#' The reactive value of a button input begins as `NULL`, but subsequently is
#' the number of clicks.
#'
#' @inheritParams input_checkbox
#'
#' @param label A character string. The text content of the button.
#'
#' @inherit input_checkbox return
#'
#' @family inputs
#'
#' @export
input_button <-
  function(
    id,
    label,
    ...
  ) {
    check_string(id, allow_empty = FALSE)

    input <-
      tags$button(
        class = "bsides-input-button btn btn-primary",
        type = "button",
        role = "button",
        id = id,
        label,
        ...
      )

    input <-
      dependency_append(input)

    input
  }

#' @rdname input_button
#' @export
update_button <-
  function(
    id,
    label = NULL,
    disable = NULL,
    session = get_current_session()
  ) {
    check_string(id, allow_empty = FALSE)

    msg <-
      drop_nulls(list(
        label = label,
        disable = disable
      ))

    session$sendInputMessage(id, msg)
  }

button_input_type <- "bsides.button"

button_input_register_handler <-
  function() {
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

#' Link input
#'
#' A button-like input, clickable text. Link inputs include a unique stretch
#' feature. With `stretch = TRUE` a link input will detect clicks on its parent
#' container. For example, a `[bslib::card]` may become clickable.
#'
#' @inheritParams input_checkbox
#'
#' @param stretch A boolean.
#'
#' @param icon A `[bsicons::bs_icon]`.
#'
#' @export
input_link <- function(
  id,
  label,
  ...,
  stretch = FALSE,
  icon = NULL
) {
  check_string(id, allow_empty = FALSE)
  check_string(label)

  input <-
    tags$a(
      class = c(
        "bsides-link",
        if (stretch) "stretched-link",
        if (!is.null(icon)) "icon-link"
      ),
      id = id,
      label,
      icon,
      ...
    )

  input <-
    dependency_append(input)

  input
}

#' @rdname input_link
#' @export
update_link <- function(
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

link_input_type <- "bsides.link"

link_input_register_handler <- function() {
  shiny::registerInputHandler(
    link_input_type,
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

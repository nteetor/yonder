#' Text inputs
#'
#' A text input.
#'
#' @inheritParams input_numeric
#'
#' @inherit input_numeric return
#'
#' @family inputs
#'
#' @export
input_text <- function(
  id,
  ...,
  value = NULL,
  placeholder = NULL
) {
  check_string(id, allow_empty = FALSE)

  args <- list(...)
  attrs <- keep_named(args)

  input <-
    tags$input(
      class = "bsides-text form-control",
      id = id,
      type = "text",
      value = value,
      placeholder = placeholder,
      !!!attrs
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_text_input", "bsides_input"))

  input
}

#' @rdname input_text
#' @export
update_text <- function(
  id,
  value = NULL,
  disable = NULL,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)

  msg <-
    drop_nulls(list(
      value = value,
      disable = disable
    ))

  session$sendInputMessage(id, msg)
}

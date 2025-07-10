#' A text group input
#'
#' A text input with a possible static prefix or suffix.
#'
#' @inheritParams input_numeric
#'
#' @param left A character vector. One or more character strings prepended to
#'   the reactive value of the input.
#'
#' @param right A character vector. One or more character strings appended to
#'   the reactive value of the input.
#'
#' @inherit input_numeric return
#'
#' @family inputs
#'
#' @export
input_text_group <- function(
  id,
  ...,
  left = NULL,
  right = NULL,
  value = NULL,
  placeholder = NULL
) {
  check_string(id, allow_empty = FALSE)

  args <- list(...)
  attrs <- keep_named(args)

  input <-
    tags$div(
      class = "bsides-textgroup input-group",
      id = id,
      !!!attrs,
      !!!text_group_input_text(left),
      tags$input(
        class = "form-control",
        type = "text"
      ),
      !!!text_group_input_text(right),
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_text_group_input", "bsides_input"))

  input
}

#' @rdname input_text_group
#' @export
update_text_group <- function(
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

text_group_input_text <- function(values) {
  lapply(values, \(v) tags$span(class = "input-group-text", v))
}

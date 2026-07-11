#' Multi select input
#'
#' The multi select input is a selectize alternative. Values typed into the
#' input become removable chips.
#'
#' @inheritParams input_checkbox
#'
#' @param select A character vector of initial values, defaults to `NULL`.
#'
#' @param placeholder A string specifying placeholder text for the input,
#'   defaults to `NULL`.
#'
#' @param max A whole number specifying the maximum number of values, defaults
#'   to `NULL`. Once reached, the text input is disabled until a value is
#'   removed.
#'
#' @returns A [htmltools::tag] object.
#'
#' @family inputs
#'
#' @export
input_multi_select <- function(
  id,
  ...,
  select = NULL,
  placeholder = NULL,
  max = NULL
) {
  check_string(id, allow_empty = FALSE)
  check_character(select, allow_null = TRUE)
  check_string(placeholder, allow_null = TRUE)
  check_number_whole(max, allow_null = TRUE)

  args <- list2(...)
  attrs <- keep_named(args)

  input <-
    htmltools::tag(
      "bsides-multi-select",
      list2(
        id = id,
        value = if (non_null(select)) {
          format(jsonlite::toJSON(select))
        },
        placeholder = placeholder,
        max = max,
        !!!attrs
      )
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, "bsides_multi_select")

  input
}

#' @rdname input_multi_select
#' @export
update_multi_select <- function(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  max = NULL,
  enable = NULL,
  disable = NULL,
  session = get_current_session()
) {}

#' Select inputs
#'
#' @description
#'
#' Create a select input. Select elements typically appear as a simple menu of
#' choices and may have one selected choice. A group select input is a select
#' input with one or two additional components. These addon components are used
#' to change the reactivity or value of the input, see Details for more
#' information.
#'
#' @inheritParams input_checkbox
#'
#' @param choices A character vector specifying the input's choices.
#'
#' @param values A character vector specifying the values of the input's
#'   choices, defaults to `choices`.
#'
#' @param selected One of `values` indicating the default value of the input,
#'   defaults to `values[[1]]`.
#'
#' @param placeholder A character string specifying the placeholder text of
#'   the select input, defaults to `NULL`.
#'
#' @family inputs
#' @export
input_select <- function(
  id,
  choices,
  ...,
  values = choices,
  select = NULL,
  disable = NULL,
  placeholder = NULL
) {
  check_string(id, allow_empty = FALSE)
  check_string(placeholder, allow_null = TRUE)

  args <- list(...)
  attrs <- keep_named(args)

  options <-
    build_input_options(
      select_option,
      choices,
      values,
      select,
      disable
    )

  input <-
    tags$select(
      class = "bsides-select form-select",
      id = id,
      !!!attrs,
      options
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_select_input", "bsides_input"))

  input
}

#' @rdname input_select
#' @export
update_select <- function(
  id,
  choices = NULL,
  values = choices,
  select = NULL,
  disable = NULL,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)

  options <-
    if (non_null(choices)) {
      build_input_options(
        select_option,
        choices,
        values,
        select,
        disable
      )
    }

  msg <-
    drop_nulls(list(
      options = options,
      select = select,
      disable = disable
    ))

  session$sendInputMessage(id, msg)
}

select_option <- function(
  choice,
  value,
  select,
  disable
) {
  tags$option(
    checked = if (value %in% select) NA,
    disabled = if (value %in% disable) NA,
    value = value,
    choice
  )
}

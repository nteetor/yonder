#' Checkbox input
#'
#' A reactive checkbox input. Users may select one or more choices. When a
#' checkbox input has no selected choices the reactive value is `NULL`.
#'
#' @param id A character string. The id of the reactive input.
#'
#' @param choices A character vector or list. The labels for the input choices.
#'
#' @param ... Optional named arguments specifying HTML attributes for the input
#'   element.
#'
#' @param values A character vector. The values for the input, defaults to
#'   `choices`.
#'
#' @param select A character vector. The values selected by default, one or more
#'   of `values`.
#'
#' @param disable A character vector. The values disabled by default.
#'
#' @param layout A character string. The layout of the input choices, one of
#'   `"column"` or `"row"`.
#'
#' @param label A character string. The placement of the choice label relative
#'   to the checkboxes, one of `"after"` or "`before`".
#'
#' @param session A shiny session object.
#'
#' @details
#'
#' ## Server value
#'
#' A named logical vector.
#'
#' @return A shiny tag object.
#'
#' @family inputs
#' @export
input_checkbox <- function(
  id,
  choices,
  ...,
  values = choices,
  select = NULL,
  disable = NULL,
  layout = "column",
  label = "after"
) {
  check_string(id, allow_empty = FALSE)
  # @TODO check choices
  check_character(values, allow_na = FALSE)
  check_character(select, allow_na = FALSE, allow_null = TRUE)
  check_character(disable, allow_na = FALSE, allow_null = TRUE)
  check_string(layout, allow_empty = FALSE)
  check_string(label, allow_empty = FALSE)

  args <- list(...)
  attrs <- keep_named(args)

  options <-
    build_input_options(
      checkbox_option,
      choices,
      values,
      select,
      disable,
      layout,
      label
    )

  tag <-
    tags$div(
      class = "bsides-checkbox",
      id = id,
      options,
      !!!attrs
    )

  tag <-
    dependency_append(tag)

  tag <-
    s3_class_add(tag, c("bsides_checkbox_input", "bsides_input"))

  tag
}

#' @rdname input_checkbox
#' @export
update_checkbox <- function(
  id,
  choices = NULL,
  values = choices,
  select = NULL,
  disable = NULL,
  layout = "column",
  label = "after",
  session = get_current_session()
) {
  options <-
    if (non_null(choices)) {
      format(
        build_input_options(
          checkbox_option,
          choices,
          values,
          select,
          disable,
          layout,
          label
        )
      )
    }

  msg <-
    drop_nulls(
      list(
        options = options,
        select = select,
        disable = disable
      )
    )

  session$sendInputMessage(id, msg)
}

checkbox_option <- function(
  choice,
  value,
  select,
  disable,
  layout,
  label
) {
  if (is.null(choice)) {
    return(NULL)
  }

  option_id <- generate_id("checkbox")

  option <-
    tags$div(
      class = c(
        "form-check",
        checkbox_class_layout(layout),
        checkbox_class_label(label)
      ),
      tags$input(
        class = "form-check-input",
        type = "checkbox",
        id = option_id,
        value = value,
        checked = if (isTRUE(value %in% select)) NA,
        disabled = if (isTRUE(value %in% disable)) NA,
        autocomplete = "off",
        `data-shiny-no-bind-input` = NA
      ),
      tags$label(
        class = "form-check-label",
        `for` = option_id,
        choice
      )
    )

  option <-
    s3_class_add(option, "bsides_checkbox_option")

  option
}

checkbox_class_layout <- function(layout) {
  switch(
    layout,
    row = "form-check-inline",
    column =
  )
}

checkbox_class_label <- function(label) {
  switch(
    label,
    before = "form-check-reverse",
    after =
  )
}

checkbox_input_handler <- function(
  value,
  session,
  name
) {
  value <- unlist(value, recursive = FALSE, use.names = TRUE)

  if (length(value) < 1 || !any(value)) {
    return(NULL)
  }

  value
}

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

  select <- values %in% select
  disable <- values %in% disable

  checkboxes <-
    build_input_choices(
      as_checkbox,
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
      checkboxes,
      !!!attrs
    )

  tag <-
    dependency_append(tag)

  tag <-
    s3_class_add(tag, c("yonder_checkbox_input", "yonder_input"))

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
  session = default_reactive_domain()
) {
  choices <-
    build_input_choices(
      as_checkbox,
      choices,
      values,
      select,
      disable,
      layout,
      label
    )

  msg <-
    list(
      choices = format(choices),
      select = select,
      disable = disable
    )

  session$sendInputMessage(id, drop_nulls(msg))
}

as_checkbox <- function(
  choice,
  value,
  select,
  disable,
  layout,
  label
) {
  if (is.null(choice) && is.null(value)) {
    return(NULL)
  }

  id <- generate_id("checkbox")

  tag <-
    tags$div(
      class = c(
        "form-check",
        checkbox_class_layout(layout),
        checkbox_class_label(label)
      ),
      tags$input(
        class = "form-check-input",
        type = "checkbox",
        id = id,
        value = value,
        checked = if (isTRUE(select)) NA,
        disabled = if (isTRUE(disable)) NA,
        autocomplete = "off",
        `data-shiny-no-bind-input` = NA
      ),
      tags$label(
        class = "form-check-label",
        `for` = id,
        choice
      )
    )

  tag <-
    s3_class_add(tag, "yonder_checkbox")

  tag
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

checkbox_handler <- function(
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

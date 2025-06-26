#' Checkbox button
#'
#' A checkbox appearing as a button.
#'
#' @inheritParams input_checkbox
#'
#' @return A shiny tag object.
#'
#' @family inputs
#' @export
input_checkbox_button <- function(
  id,
  choices,
  ...,
  values = choices,
  select = NULL,
  disable = NULL,
  layout = "row"
) {
  check_string(id, allow_empty = FALSE)
  # @TODO check choices
  check_character(values, allow_na = FALSE, allow_null = FALSE)
  check_character(select, allow_null = TRUE)
  check_character(disable, allow_null = TRUE)

  args <- list(...)
  attrs <- keep_named(args)

  options <-
    build_input_options(
      checkbox_button_option,
      choices,
      values,
      select,
      disable
    )

  input <-
    tags$div(
      id = id,
      class = c(
        "bsides-checkbox-button",
        checkbox_button_class_layout(layout)
      ),
      role = "group",
      options,
      !!!attrs
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_checkbox_button_input", "bsides_input"))

  input
}

#' @rdname input_checkbox_button
#' @export
update_checkbox_button <- function(
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
      format(
        build_input_options(
          checkbox_button_option,
          choices,
          values,
          select,
          disable
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

checkbox_button_option <- function(
  choice,
  value,
  select,
  disable
) {
  option_id <- generate_id("checkbox")

  option <-
    list(
      tags$input(
        type = "checkbox",
        class = "btn-check",
        id = option_id,
        value = value,
        checked = if (isTRUE(value %in% select)) NA,
        disabled = if (isTRUE(value %in% disable)) NA,
        autocomplete = "off",
        `data-shiny-no-bind-input` = NA
      ),
      tags$label(
        class = "btn btn-outline-primary",
        `for` = option_id,
        choice
      )
    )

  option <-
    s3_class_add(option, "bsides_checkbox_button_option")

  option
}

checkbox_button_class_layout <- function(
  layout
) {
  if (layout == "row") {
    "btn-group"
  } else {
    "btn-group-vertical"
  }
}

checkbox_button_input_handler <- function(
  value,
  session,
  name
) {
  value <- unlist(value, FALSE, TRUE)

  if (length(value) < 1 || !any(value)) {
    return(NULL)
  }

  value
}

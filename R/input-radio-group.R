#' Radio inputs
#'
#' A stylized radio input. A reactive input with multiple choices where only one
#' choice and value at most may be selected.
#'
#' @inheritParams input_checkbox_group
#'
#' @family inputs
#' @export
input_radio_group <- function(
  id,
  choices,
  ...,
  values = choices,
  select = NULL,
  disable = NULL,
  appearance = c("default", "buttons", "switches", "list"),
  layout = c("column", "row"),
  label = c("after", "before")
) {
  check_string(id, allow_empty = FALSE)

  appearance <- arg_match(appearance)
  layout <- arg_match(layout)
  label <- arg_match(label)

  args <- list(...)
  attrs <- keep_named(args)

  options <-
    build_input_options(
      radio_group_option,
      choices,
      values,
      select,
      disable,
      appearance,
      layout,
      label,
      input_id = id
    )

  input <-
    (if (appearance == "list") tags$ul else tags$div)(
      class = c(
        "bsides-radiogroup",
        if (appearance == "list") "list-group",
        if (appearance == "buttons") {
          if (layout == "row") {
            "btn-group"
          } else {
            "btn-group-vertical"
          }
        }
      ),
      id = id,
      options,
      !!!attrs
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_radio_group_input", "bsides_input"))

  input
}

#' @rdname input_radio_group
#' @export
update_radio_group <- function(
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
        radio_group_option,
        choices,
        values,
        select,
        disable,
        input_id = id
      )
    }

  msg <-
    drop_nulls(list(
      optins = options,
      select = select,
      disable = disable
    ))

  session$sendInputMessage(id, msg)
}

radio_group_option <- function(
  choice,
  value,
  select,
  disable,
  appearance,
  layout,
  label,
  input_id
) {
  func <- switch(
    appearance,
    default = radio_group_option_default,
    buttons = radio_group_option_button,
    switches = radio_group_option_switch,
    list = radio_group_option_list_item
  )

  func(choice, value, select, disable, layout, label, input_id)
}

radio_group_option_default <- function(
  choice,
  value,
  select,
  disable,
  layout,
  label,
  input_id
) {
  option_id <- generate_id("radio")

  tags$div(
    class = c(
      "form-check",
      if (layout == "row") "form-check-inline",
      if (label == "before") "form-check-reverse"
    ),
    tags$input(
      class = "form-check-input",
      type = "radio",
      id = option_id,
      name = input_id,
      value = value,
      checked = if (value %in% select) NA,
      disabled = if (value %in% disable) NA,
      autocomplete = "off",
      `data-shiny-no-bind-input` = NA
    ),
    tags$label(
      class = "form-check-label",
      `for` = option_id,
      choice
    )
  )
}

radio_group_option_button <- function(
  choice,
  value,
  select,
  disable,
  layout,
  label,
  input_id
) {
  option_id <- generate_id("radio")

  list(
    tags$input(
      class = "btn-check",
      type = "radio",
      id = option_id,
      name = input_id,
      value = value,
      checked = if (value %in% select) NA,
      disabled = if (value %in% disable) NA,
      autocomplete = "off",
      `data-shiny-no-bind-input` = NA
    ),
    tags$label(
      class = "btn btn-outline-primary",
      `for` = option_id,
      choice
    )
  )
}

radio_group_option_switch <- function(
  choice,
  value,
  select,
  disable,
  layout,
  label,
  input_id
) {
  option_id <- generate_id("radio")

  tags$div(
    class = c(
      "form-check form-switch",
      if (layout == "row") "form-check-inline",
      if (label == "before") "form-check-reverse"
    ),
    tags$input(
      class = "form-check-input",
      type = "radio",
      id = option_id,
      name = input_id,
      value = value,
      checked = if (value %in% select) NA,
      disabled = if (value %in% disable) NA,
      autocomplete = "off",
      `data-shiny-no-bind-input` = NA
    ),
    tags$label(
      class = "form-check-label",
      `for` = option_id,
      choice
    )
  )
}

radio_group_option_list_item <- function(
  choice,
  value,
  select,
  disable,
  layout,
  label,
  input_id
) {
  option_id <- generate_id("radio")

  tags$li(
    class = c(
      "list-group-item",
      if (label == "before") "form-check-reverse"
    ),
    tags$input(
      class = "form-check-input me-0 ms-1",
      id = option_id,
      name = input_id,
      value = value,
      type = "radio",
      autocomplete = "off",
      checked = if (value %in% select) NA,
      disabled = if (value %in% disable) NA,
      `data-shiny-no-bind-input` = NA
    ),
    tags$label(
      class = "form-check-label stretched-link",
      `for` = option_id,
      choice
    )
  )
}

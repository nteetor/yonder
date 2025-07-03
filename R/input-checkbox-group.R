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
#' @param appearance A character string. The appearance of the input's
#'   checkboxes.
#'
#' @param layout A character string. The layout of the choices.
#'
#' @param label A character string. The placement of a label relative to its
#'   checkbox.
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
input_checkbox_group <- function(
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
  # @TODO check choices
  check_character(values, allow_na = FALSE)
  check_character(select, allow_na = FALSE, allow_null = TRUE)
  check_character(disable, allow_na = FALSE, allow_null = TRUE)

  appearance <- arg_match(appearance)
  layout <- arg_match(layout)
  label <- arg_match(label)

  args <- list(...)
  attrs <- keep_named(args)

  options <-
    build_input_options(
      checkbox_group_option,
      choices,
      values,
      select,
      disable,
      appearance,
      layout,
      label
    )

  input <-
    checkbox_group_container(
      id,
      appearance,
      attrs
    )

  input <-
    tag_children_add(input, !!!options)

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_checkbox_group_input", "bsides_input"))

  input
}

#' @rdname input_checkbox
#' @export
update_checkbox_group <- function(
  id,
  choices = NULL,
  values = choices,
  select = NULL,
  disable = NULL,
  layout = "column",
  label = "after",
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)
  check_character(values, allow_null = TRUE)
  check_character(select, allow_null = TRUE)
  check_character(disable, allow_null = TRUE)

  options <-
    if (non_null(choices)) {
      format(
        build_input_options(
          checkbox_group_option,
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

checkbox_group_class <- "bsides-checkboxgroup"

checkbox_group_container <- function(
  id,
  appearance,
  attrs
) {
  switch(
    appearance,
    default = tags$div(
      class = checkbox_group_class,
      id = id,
      !!!attrs
    ),
    buttons = tags$div(
      class = c(
        checkbox_group_class,
        "btn-group"
      ),
      id = id,
      role = "group",
      !!!attrs
    ),
    switches = tags$div(
      class = checkbox_group_class,
      id = id,
      !!!attrs
    ),
    list = tags$ul(
      class = c(
        checkbox_group_class,
        "list-group",
        "d-inline-flex"
      ),
      id = id,
      !!!attrs
    )
  )
}

checkbox_group_option <- function(
  choice,
  value,
  select,
  disable,
  appearance,
  layout,
  label
) {
  if (is.null(choice)) {
    return(NULL)
  }

  option_id <- generate_id("checkbox")

  option <-
    checkbox_group_option_func(appearance)(
      option_id,
      choice,
      value,
      select,
      disable,
      layout,
      label
    )

  option <-
    s3_class_add(option, "bsides_checkbox_group_option")

  option
}

checkbox_group_option_func <- function(
  appearance
) {
  switch(
    appearance,
    default = checkbox_group_option_default,
    buttons = checkbox_group_option_button,
    switches = checkbox_group_option_switch,
    list = checkbox_group_option_list_item
  )
}

checkbox_group_option_default <- function(
  id,
  choice,
  value,
  select,
  disable,
  layout,
  label
) {
  tags$div(
    class = c(
      "form-check",
      checkbox_group_option_class_label(label),
      checkbox_group_option_class_layout(layout)
    ),
    tags$input(
      class = "form-check-input",
      id = id,
      value = value,
      type = "checkbox",
      autocomplete = "off",
      !!!checkbox_group_option_attr_checked(value, select),
      !!!checkbox_group_option_attr_disabled(value, disable),
      `data-shiny-no-bind-input` = NA
    ),
    tags$label(
      class = "form-check-label",
      `for` = id,
      choice
    )
  )
}

checkbox_group_option_button <- function(
  id,
  choice,
  value,
  select,
  disable,
  layout,
  label
) {
  list(
    tags$input(
      class = "btn-check",
      id = id,
      value = value,
      type = "checkbox",
      autocomplete = "off",
      `data-shiny-no-bind-input` = NA
    ),
    tags$label(
      class = "btn btn-outline-primary",
      `for` = id,
      choice
    )
  )
}

checkbox_group_option_switch <- function(
  id,
  choice,
  value,
  select,
  disable,
  layout,
  label
) {
  tags$div(
    class = c(
      "form-check",
      "form-switch",
      checkbox_group_option_class_label(label),
      checkbox_group_option_class_layout(layout)
    ),
    tags$input(
      class = "form-check-input",
      id = id,
      value = value,
      type = "checkbox",
      autocomplete = "off",
      !!!checkbox_group_option_attr_checked(value, select),
      !!!checkbox_group_option_attr_disabled(value, disable),
      `data-shiny-no-bind-input` = NA
    ),
    tags$label(
      class = "form-check-label",
      `for` = id,
      choice
    )
  )
}

checkbox_group_option_list_item <- function(
  id,
  choice,
  value,
  select,
  disable,
  layout,
  label
) {
  tags$li(
    class = c(
      "list-group-item",
      checkbox_group_option_class_label(label)
    ),
    tags$input(
      class = "form-check-input me-0 ms-1",
      id = id,
      value = value,
      type = "checkbox",
      autocomplete = "off",
      !!!checkbox_group_option_attr_checked(value, select),
      !!!checkbox_group_option_attr_disabled(value, disable),
      `data-shiny-no-bind-input` = NA
    ),
    tags$label(
      class = "form-check-label stretched-link",
      `for` = id,
      choice
    )
  )
}

checkbox_group_option_attr_checked <- function(
  value,
  select
) {
  if (isTRUE(value %in% select)) {
    list(checked = NA)
  }
}

checkbox_group_option_attr_disabled <- function(
  value,
  disable
) {
  if (isTRUE(value %in% disable)) {
    list(disabled = NA)
  }
}

checkbox_group_option_class_appearance <- function(
  appearance
) {
  switch(
    appearance,
    default = "form-check",
    switches = "form-check form-switch",
    buttons = NULL,
    list = NULL
  )
}

checkbox_group_option_class_layout <- function(
  layout
) {
  switch(
    layout,
    row = "form-check-inline",
    column =
  )
}

checkbox_group_option_class_label <- function(
  label
) {
  switch(
    label,
    before = "form-check-reverse",
    after =
  )
}

checkbox_group_input_type <- "bsides.checkboxgroup"

checkbox_group_input_register_handler <- function() {
  shiny::registerInputHandler(
    checkbox_group_input_type,
    function(
      value,
      session,
      name
    ) {
      if (length(value) < 1) {
        return(NULL)
      }

      unlist(value, recursive = FALSE, use.names = FALSE)
    },
    force = TRUE
  )
}

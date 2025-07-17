#' List group inputs
#'
#' List group inputs are an actionable list of items. They behave similarly to
#' checkboxes or radios, that is, users may select one or more items from the
#' list. However, list group items may include highly variable content.
#'
#' @inheritParams input_checkbox_group
#'
#' @param appearance A character string. The appearance of the input's list
#'   items.
#'
#'   Flush list items have their outer borders and rounded corners removed.
#'
#' @param layout <[responsive]> A character vector. The layout of the choices.
#'
#' @family inputs
#' @export
input_list_group <- function(
  id,
  choices,
  ...,
  values = choices,
  select = NULL,
  disable = NULL,
  appearance = c("default", "flush"),
  layout = c("column", "row")
) {
  check_string(id, allow_empty = FALSE)

  check_character(values)
  check_character(select, allow_null = TRUE)
  check_character(disable, allow_null = TRUE)

  appearance <- arg_match(appearance)
  layout <- arg_match(layout)

  args <- list(...)
  attrs <- keep_named(args)

  options <-
    build_input_options(
      list_group_option,
      choices,
      values,
      select,
      disable
    )

  input <-
    tags$div(
      class = c(
        "bsides-listgroup",
        "list-group",
        list_group_class_flush(appearance),
        list_group_class_layout(layout)
      ),
      id = id,
      !!!attrs,
      !!!options
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_list_group_input", "bsides_input"))

  input
}

#' @rdname input_list_group
#' @export
update_list_group <- function(
  id,
  choices = NULL,
  values = choices,
  select = NULL,
  disable = NULL,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)
  check_character(values)
  check_character(select, allow_null = TRUE)
  check_character(disable, allow_null = TRUE)

  msg <-
    drop_nulls(list(
      select = select,
      disable = disable
    ))

  session$sendInputMessage(id, msg)
}

list_group_class_flush <- function(
  appearance
) {
  if (appearance == "flush") {
    "list-group-flush"
  }
}

list_group_class_layout <- function(
  layout
) {
  if (is_breakpoints(layout)) {
    layout[layout == "row"] <- "horizontal"
    layout[layout == "column"] <- NULL

    sprintf("list-group-%s-%s", layout, names(layout))
  } else if (layout == "row") {
    "list-group-horizontal"
  }
}

list_group_option <- function(
  choice,
  value,
  select,
  disable
) {
  if (is.null(choice)) {
    return(NULL)
  }

  tags$a(
    class = c(
      "list-group-item",
      "list-group-item-action",
      list_group_option_class_select(value, select),
      list_group_option_class_disable(value, disable)
    ),
    `data-bsides-value` = value,
    choice
  )
}

list_group_option_class_select <- function(
  value,
  select
) {
  if (isTRUE(value %in% select)) {
    "active"
  }
}

list_group_option_class_disable <- function(
  value,
  disable
) {
  if (isTRUE(value %in% disable)) {
    "disabled"
  }
}

list_group_input_type <- "bsides.listgroup"

list_group_input_register_handler <- function() {
  shiny::registerInputHandler(
    list_group_input_type,
    function(
      value,
      session,
      name
    ) {
      if (length(value) > 1) {
        return(NULL)
      }

      unlist(value, recursive = FALSE, use.names = FALSE)
    },
    force = TRUE
  )
}

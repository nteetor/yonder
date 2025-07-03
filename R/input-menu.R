#' Menu inputs
#'
#' A dropdown menu.
#'
#' @inheritParams input_checkbox_group
#'
#' @param label A character string or tag element specifying the label of the
#'   menu's toggle button.
#'
#' @param choices A character vector specifying the choice text of the menu's
#'   items.
#'
#' @param values A character vector specifying the values of the menu's items,
#'   defaults to `choices`.
#'
#' @param direction One of `"up"`, `"right"`, `"down"`, or `"left"` specifying
#'   which direction the menu opens, defaults to `"down"`.
#'
#' @param align One or `"right"` or `"left"` specifying which side of the
#'   toggle button the menu aligns to, defaults to `"left"`.`
#'
#' @family inputs
#' @export
input_menu <- function(
  id,
  label,
  choices,
  ...,
  values = choices,
  select = NULL,
  disable = NULL,
  menu_options = NULL
) {
  check_string(id)
  check_string(label)

  args <- list(...)
  attrs <- keep_named(args)

  options <-
    build_input_options(
      menu_option,
      choices,
      values,
      select,
      disable
    )

  input <-
    tags$div(
      class = "bsides-menu btn-group",
      id = id,
      !!!attrs,
      tags$button(
        class = "btn btn-primary dropdown-toggle",
        type = "button",
        `data-bs-toggle` = "dropdown",
        `aria-expanded` = "false",
        label
      ),
      tags$ul(
        class = "dropdown-menu",
        options
      )
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_menu_input", "bsides_input"))

  input
}

#' @rdname input_menu
#' @export
update_menu_input <- function(
  id,
  label = NULL,
  choices = NULL,
  values = choices,
  selected = NULL,
  enable = NULL,
  disable = NULL,
  session = getDefaultReactiveDomain()
) {
  assert_id()
  assert_label()
  assert_choices()
  assert_selected(len = 1)
  assert_session()

  items <- map_menuitems(choices, values, selected)

  label <- coerce_content(label)
  content <- coerce_content(items)
  selected <- coerce_selected(selected)
  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(
    id,
    list(
      label = label,
      content = content,
      selected = selected,
      enable = enable,
      disable = disable
    )
  )
}

#' Menu options.
#'
#' Construct an options object for a menu input.
#'
#' @param direction A character string.
#'
#' @param <[responsive]> A character string.
#'
#' @param close
#'
#' @returns A list of menu options.
#'
#' @export
menu_options <- function(
  direction = c("down", "up", "left", "right"),
  align = c("left", "right"),
  close = c("auto", "inside", "outside", "manual")
) {
  direction <- arg_match(direction)
  align <- arg_match(align)
  close <- arg_match(close)

  list(
    parent = list(
      class = NULL
    ),
    toggle = list(
      class = NULL,
      `data-bs-disply` = NULL,
      `data-bs-auto-close` = NULL
    ),
    menu = list(
      class = NULL
    )
  )
}
#
#   options$parent$class <-
#     switch(
#       direction,
#       down = NULL,
#       up = "dropup",
#       left = "dropstart",
#       right = "dropend"
#     )
#
#   if (is_breakpoints(align)) {
#     align["left"] <- "start"
#     align["right"] <- "end"
#
#     options$menu$class <-
#       sprintf("dropdown-menu-%s-%s", names(align), align)
#
#     options$toggle$`data-bs-display` <-
#       "static"
#   } else {
#     options$menu$class <-
#       sprintf("dropdown-menu-%s", align)
#   }
#
#   list(
#     direction = list(class = direction),
#     align = list(class = align)
#   )
# }

menu_option <- function(
  choice,
  value,
  select,
  disable
) {
  if (is.null(choice)) {
    return(NULL)
  }

  tags$li(
    tags$button(
      class = c(
        "dropdown-item",
        if (isTRUE(value %in% select)) "active",
        if (isTRUE(value %in% disable)) "disabled"
      ),
      type = "button",
      value = value,
      choice
    )
  )
}

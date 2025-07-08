#' Menu inputs
#'
#' A dropdown menu.
#'
#' @inheritParams input_checkbox_group
#'
#' @param label A character string or tag element specifying the label of the
#'   menu's toggle button.
#'
#' @param direction A character string.
#'
#' @param align <[responsive]> A character vector.
#'
#' @param close A character string.
#'
#' @family inputs
#' @export
input_menu <- function(
  id,
  label,
  choices,
  ...,
  values = choices,
  disable = NULL,
  direction = c("down", "up", "left", "right"),
  align = c("left", "right"),
  close = c("auto", "inside", "outside", "manual")
) {
  check_string(id, allow_empty = FALSE)

  direction <- arg_match(direction)
  align <- if (!is_breakpoints(align)) arg_match(align)
  close <- arg_match(close)

  args <- list(...)
  attrs <- keep_named(args)

  options <-
    build_input_options(
      menu_option,
      choices,
      values,
      disable
    )

  input <-
    tags$div(
      class = "bsides-menu",
      !!!menu_container_attrs(direction, align),
      id = id,
      !!!attrs,
      tags$button(
        class = "btn btn-primary dropdown-toggle",
        type = "button",
        `data-bs-toggle` = "dropdown",
        `aria-expanded` = "false",
        !!!menu_toggle_attrs(align),
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
  select = NULL,
  disable = NULL,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)

  msg <-
    drop_nulls(list(
      label = label,
      select = select,
      disable = disable
    ))

  session$sendInputMessage(id, msg)
}

#' Menu choices
#'
#'
menu_choices <- function(
  ...
) {}

menu_choice <- function(
  label,
  value,
  ...,
  disable = NULL
) {}

menu_divider <- function() {}

menu_text <- function(text) {}

menu_option <- function(
  choice,
  value,
  disable
) {
  if (is.null(choice)) {
    return(NULL)
  }

  option <-
    tags$li(
      tags$button(
        class = c(
          "dropdown-item",
          if (isTRUE(value %in% disable)) "disabled"
        ),
        type = "button",
        value = value,
        choice
      )
    )

  option <-
    s3_class_add(option, "bsides_menu_input_choice")

  option
}

menu_container_attrs <- function(
  direction,
  align
) {
  attrs <- list(
    class = NULL
  )

  attrs$class <-
    if (isTRUE(align == "centered")) {
      switch(
        direction,
        down = "dropdown-centered",
        up = "downup-centered"
      )
    } else {
      switch(
        direction,
        down = "dropdown",
        up = "dropup",
        left = "dropstart",
        right = "dropend"
      )
    }

  attrs
}

menu_toggle_attrs <- function(
  align
) {
  attrs <-
    list(
      class = NULL,
      `data-bs-display` = NULL
    )

  if (is_breakpoints(align)) {
    align["left"] <- "start"
    align["right"] <- "end"

    attrs$class <-
      sprintf("dropdown-menu-%s-%s", names(align), align)

    attrs$`data-bs-display` <-
      "static"
  } else {
    attrs$class <-
      sprintf("dropdown-menu-%s", align)
  }

  attrs
}

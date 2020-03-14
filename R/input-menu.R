#' Menu inputs
#'
#' A toggleable dropdown menu input. Menu inputs may be used as standalone
#' reactive inputs or within a [navInput()]. For building custom, more complex
#' dropdown elements please see [dropdown()].
#'
#' @inheritParams checkboxInput
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
#' @includeRmd man/roxygen/menu.Rmd
#'
#' @family inputs
#' @export
menuInput <- function(id, label, choices = NULL, values = choices,
                      selected = NULL, ..., direction = "down",
                      align = "left") {
  assert_id()
  assert_choices()
  assert_possible(direction, c("up", "right", "down", "left"))
  assert_possible(align, c("right", "left"))

  tag <- dep_attach({
    items <- map_menuitems(choices, values, selected)

    tags$div(
      class = str_collate(
        "yonder-menu",
        paste0("drop", direction)
      ),
      id = id,
      tags$button(
        class = "btn dropdown-toggle",
        type = "button",
        `data-toggle` = "dropdown",
        `aria-haspopup` = "true",
        `aria-expanded` = "false",
        label
      ),
      ...,
      tags$div(
        class = str_collate(
          "dropdown-menu",
          if (align == "right") "dropdown-menu-right"
        ),
        items
      )
    )
  })

  s3_class_add(tag, c("yonder_menu", "yonder_input"))
}

#' @rdname menuInput
#' @export
updateMenuInput <- function(id, label = NULL, choices = NULL, values = choices,
                            selected = NULL, enable = NULL, disable = NULL,
                            session = getDefaultReactiveDomain()) {
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

  session$sendInputMessage(id, list(
    label = label,
    content = content,
    selected = selected,
    enable = enable,
    disable = disable
  ))
}

map_menuitems <- function(choices, values, selected) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      tags$button(
        class = str_collate(
          "dropdown-item",
          if (select) "active"
        ),
        type = "button",
        value = value,
        choice
      )
    }
  )
}

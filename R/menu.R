#' Menu input
#'
#' A togglable dropdown menu input. Menu inputs may be used as standalone
#' reactive inputs or within a [navInput()]. For building custom, more complex
#' dropdown elements please see [dropdown()].
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
#' @template input
#' @export
#' @examples
#'
#' ### A simple menu
#'
#' menuInput(
#'   id = "menu1",
#'   label = "Menu",
#'   choices = c(
#'     "Choice 1",
#'     "Choice 2",
#'     "Choice 3"
#'   )
#' )
#'
#' ### Use in navigation
#'
#' navInput(
#'   id = "nav1",
#'   choices = list(
#'     "Tab 1",
#'     menuInput(
#'       id = "navOptions",
#'       label = "Tab 2",
#'       choices = c(
#'         "Option 1",
#'         "Option 2",
#'         "Option 3"
#'       )
#'     ),
#'     "Tab 3",
#'     "Tab 4"
#'   ),
#'   values = paste0("tab", 1:4)
#' )
#'
menuInput <- function(id, label, choices, values = choices, ...,
                      direction = "down", align = "left") {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `menuInput()` argument, `id` must be a character string or NULL",
      call. = FALSE
    )
  }

  if (missing(choices) && missing(values) && !missing(label)) {
    stop(
      "invalid `menuInput()` argument, `label` must be specified",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `menuInput()` arguments, `choices` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!re(direction, "up|right|down|left", len0 = FALSE)) {
    stop(
      "invalid `menuInput()` arugment, `direction` must be one of ",
      '"up", "right", "down", or "left"',
      call. = FALSE
    )
  }

  if (!re(align, "right|left", len0 = FALSE)) {
    stop(
      "invalid `menuInput()` argument, `align` must be one of ",
      '"right" or "left"',
      call. = FALSE
    )
  }

  element <- tags$div(
    class = collate(
      "yonder-menu",
      paste0("drop", direction)
    ),
    id = id,
    tags$button(
      class = "btn btn-grey dropdown-toggle",
      type = "button",
      `data-toggle` = "dropdown",
      `aria-haspopup` = "true",
      `aria-expanded` = "false",
      label
    ),
    tags$div(
      class = collate(
        "dropdown-menu",
        if (align == "right") "dropdown-menu-right"
      ),
      Map(
        choice = choices,
        value = values,
        function(choice, value) {
          tags$button(
            class = "dropdown-item",
            type = "button",
            value = value,
            choice
          )
        }
      )
    )
  )

  attachDependencies(
    element,
    c(yonderDep(), shinyDep(), bootstrapDep())
  )
}

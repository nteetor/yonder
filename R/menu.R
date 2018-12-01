#' Menu input
#'
#' A togglable dropdown menu input. Menu inputs may be used as standalone
#' reactive inputs or within a [navInput()]. When used within a nav input the
#' `id` argument is ignored and may be set to `NULL`. For building custom,
#' more complex dropdown elements please see [dropdown()].
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
#'   choice = list(
#'     "Tab 1",
#'     menuInput(
#'       id = NULL,  # <- ignored
#'       label = "Tab 2",
#'       choices = c(
#'         "Option 1",
#'         "Option 2",
#'         "Option 3"
#'       )
#'     ),
#'     "Tab 3",
#'     "Tab 4"
#'   )
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

  shiny::registerInputHandler(
    type = "yonder.menu",
    fun = function(x, session, data) {
      if (length(x) > 1) x[[2]]
    },
    force = TRUE
  )

  input <- tags$div(
    class = collate(
      "yonder-menu",
      paste0("drop", direction)
    ),
    id = id,
    tags$a(
      class = "btn btn-grey dropdown-toggle",
      href = "#",
      role = "button",
      `data-toggle` = "dropdown",
      label
    ),
    tags$div(
      class = "dropdown-menu",
      Map(
        choice = choices,
        value = values,
        function(choice, value) {
          tags$a(
            class = "dropdown-item",
            href = "#",
            `data-value` = value,
            choice
          )
        }
      )
    )
  )

  input <- attachDependencies(input, c(yonderDep(), shinyDep(), bootstrapDep()))

  input
}

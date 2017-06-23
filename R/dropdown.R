#' Dropdown Menu
#'
#' A Bootstrap dropdown menu.
#'
#' @param button A button to trigger the dropdown, see `button`.
#'
#' @param links A list of `tags$a` elements.
#'
#' @param ... Additional named arguments passed on as HTML attributes.
#'
#' @export
#' @examples
#' # A dropdown without `id` attribute
#' #   - standard `tags$a` utility
#' dropdown(
#'   button("Secondary"),
#'   list(
#'     tags$a(href = "#", "Option 1"),
#'     tags$a(href = "3", "Option 2")
#'   )
#' )
#'
#' # A dropdown with `id` attribute
#' #   - `tags$a` now act similar `shiny::actionButton`
#' #   - when `tags$a` clicked `input$flavor` will have `href` value
#' #   - default `tags$a` behavior suppressed
#' dropdown(
#'   id = "flavor",
#'   button("Ice cream flavors"),
#'   list(
#'     tags$a(href = "vanilla", "Vanilla"),
#'     tags$a(href = "chocolate", "Chocolate"),
#'     tags$a(href = "mint", "Mint")
#'   )
#' )
#'
dropdown <- function(button = NULL, links = NULL, ...) {
  tags$div(
    class = "dropdown dull-dropdown",
    if (!is.null(button)) {
      button <- tagEnsureClass(button, "dropdown-toggle")
      button$attribs$`data-toggle` <- "dropdown"
      button
    },
    if (!is.null(links)) {
      tags$div(
        class = "dropdown-menu",
        lapply(
          links,
          function(x) {
            if (!is_tag(x) || x$name != "a") {
              return(x)
            }

            tagEnsureClass(x, "dropdown-item")
          }
        )
      )
    },
    ...
  )
}

#' Dropdown Menu
#'
#' A Bootstrap dropdown menu.
#'
#' @param ... `dropdownItem`s passed to `dropdown` or additional named arguments
#'   passed as HTML attributes to the parent element.
#'
#' @param button A button element used to trigger the dropdown, see `button`.
#'
#' @export
#' @examples
#' # A dropdown without `id` attribute
#' #   - standard `tags$a` utility
#' dropdown(
#'   button = button("Secondary"),
#'   dropdownItem("Option 1", href = "#"),
#'   dropdownItem("Option 2", href = "#")
#' )
#'
#' # A dropdown with `id` attribute
#' #   - now `dropdownItem`s similar to `shiny::actionButton`
#' #   - when clicked `dropdownItem` will have `href` value
#' dropdown(
#'   id = "flavor",
#'   button = button("Ice cream flavors"),
#'   dropdownItem("Vanilla", href = "vanilla"),
#'   dropdownItem("Chocolate", href = "chocolate"),
#'   dropdownItem("Mint", href = "mint")
#' )
#'
dropdown <- function(button = NULL, ...) {
  tags$div(
    class = "dropdown dull-dropdown",
    if (!is.null(button)) {
      button <- tagEnsureClass(button, "dropdown-toggle")
      button$attribs$`data-toggle` <- "dropdown"
      button
    },
    ...,
    bootstrap()
  )
}

dropdownItem <- function() {
  stop("not implemented")
}

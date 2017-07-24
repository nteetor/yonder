#' Page Navigation
#'
#' Create a nav.
#'
#' @param ... `navItem`s or `navDropdown`s passed to `nav`, `dropdownItem`s
#'   passed to `navDropdown`, or named arguments passed as HTML attributes to
#'   the respective parent element.
#'
#' @param align One of `"left"`, `"right"`, `"center"`, or `"horizontal"`
#'   specifying the alignment of the nav, defaults to `"left"`.
#'
#' @param width If specified, one of `"fill"` or `"justify"` specifying how the
#'   nav will fill its parent element, defaults to `NULL`. If `"justify"` all
#'   nav links have equal width, when `"fill"` nav links are only equally
#'   spaced.
#'
#' @param vertical If `TRUE`, the nav is rendered vertically, defaults to
#'   `FALSE`.
#'
#' @param tabs If `TRUE`, the nav is rendered as a set of tabs for a tabbed
#'   interface, defaults to `FALSE`.
#'
#' @param pills If `TRUE`, `navItem`s are rendered as pills, defaults to
#'   `FALSE`.
#'
#' @param label A character vector specifying the label of a nav item,
#'   defaults to `NULL`.
#'
#' @param active If `TRUE`, the nav item renders in a an active state, defaults
#'   to `FALSE`.
#'
#' @param disabled If `TRUE`, the nav item renders in a disabled state and
#'   will not receive click events, defaults to `FALSE`.
#'
#' @details
#'
#' To center a horizontal nav specify `align = "horiztonal"` and `width =
#' "fill"` or `width = "justify"`.
#'
#' @seealso
#'
#' For more information about the Bootstrap nav please follow this
#' [link](http://v4-alpha.getbootstrap.com/components/navs/).
#'
#' @examples
#' nav(
#'   navItem("Home", href = "#home"),
#'   navItem("About", href = "#about")
#' )
#'
#' # active link
#' nav(
#'   navItem("Home", href = "#home", active = TRUE),
#'   navItem("About", href = "#about")
#' )
#'
#' # active tab
#' nav(
#'   tabs = TRUE,
#'   navItem("Home", href = "#home", active = TRUE),
#'   navItem("About", href = "#about"),
#'   navItem("Blog", href = "#blog")
#' )
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       nav(
#'         navItem(
#'           label = "Home",
#'           active = TRUE
#'         ),
#'         navItem(
#'           label = "Posts"
#'         ),
#'         navItem(
#'           label = "About"
#'         ),
#'         navDropdown(
#'           dropdownItem()
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
nav <- function(..., align = "left", width = NULL, vertical = FALSE,
                tabs = FALSE, pills = FALSE) {
  if (!(align %in% c("right", "left", "center"))) {
    stop(
      'invalid `nav` argument, `align` must be "right", "left", or "center"',
      call. = FALSE
    )
  }

  tags$ul(
    class = collate(
      "nav",
      if (tabs) "nav-tabs",
      if (pills) "nav-pills",
      if (align == "right") "justify-content-end" else if (align == "center")
        "justify-content-center",
      if (vertical) "flex-column"
    ),
    role = collate(
      "navigation",
      if (tabs) "tablist"
    ),
    ...,
    bootstrap()
  )
}

#' @rdname nav
#' @export
navItem <- function(label = NULL, active = FALSE, disabled = FALSE, ...) {
  tags$li(
    class = "nav-item",
    tags$a(
      class = collate(
        "nav-link",
        if (active) "active",
        if (disabled) "disabled"
      ),
      label
    ),
    bootstrap()
  )
}

#' @rdname nav
#' @export
navDropdown <- function(label = NULL, ...) {
  tags$li(
    class = "nav-item dropdown",
    tags$a(
      class = "nav-link dropdown-toggle",
      `data-toggle` = "dropdown",
      role = "button",
      `aria-haspopup` = TRUE,
      `aria-expanded` = FALSE,
      label
    ),
    ...,
    bootstrap()
  )
}

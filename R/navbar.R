#' Page and content navigation
#'
#' Add a navigation bar to your application with `navbar()`. Navigation bars may
#' include a tab toggle (useful for multi-page applications), inline forms
#' (perhaps a search feature or login item), or character strings to add simple
#' text. Navbars are responsive and will collapse on small screens, think mobile
#' device. A button is automatically added to toggle between the collapsed and
#' expanded states.
#'
#' @param ... A tab toggle, inline forms, or text to add to include as part of
#'   the navigation bar.
#'
#' @param brand A tag element or text placed on the left end of the navbar,
#'   defaults to `NULL`, in which case nothing is added.
#'
#' @family layout
#' @export
#' @examples
#'
#' ### Navbar with tabs
#'
#' div(
#'   navbar(
#'     brand = "Navbar",
#'     navInput(
#'       id = "tabs",
#'       items = c("Home", "About", "Our process")
#'     ) %>%
#'       margin(right = "auto"),
#'     formInput(
#'       inline = TRUE,
#'       id = "navForm",
#'       searchInput("search", placeholder = "Search") %>%
#'         margin(right = c(sm = 2)),
#'       submit = submitInput("Search") %>%
#'         background("amber")
#'     )
#'   ) %>%
#'     background("teal"),
#'   container(
#'     navContent(
#'       navPane(
#'         h3("Home")
#'       ),
#'       navPane(
#'         h3("About")
#'       ),
#'       navPane(
#'         h3("The process")
#'       )
#'     )
#'   )
#' )
#'
navbar <- function(..., brand = NULL) {
  args <- list(...)
  attrs <- attribs(args)

  elems <- lapply(
    elements(args),
    function(arg) {
      if (tagHasClass(arg, "nav")) {
        arg <- tagDropClass(arg, "nav-tabs|nav-pills")
        arg <- tagAddClass(arg, "navbar-nav")
      } else if (tagIs(arg, "form")) {
        if (!tagHasClass(arg, "form-inline")) {
          warning("non-inline form element passed to `navbar()`", call. = FALSE)
        }
      } else if (!is_tag(arg)) {
        arg <- tags$span(class = "navbar-text", arg)
      }

      arg
    }
  )

  brand <- if (!is.null(brand)) {
    tags$a(
      class = "navbar-brand",
      href = "#",
      brand
    )
  }

  navContentId <- ID("navContent")

  this <- tags$nav(
    class = "navbar navbar-expand-lg navbar-light",
    brand,
    tags$button(
      class = "navbar-toggler",
      type = "button",
      `data-toggle` = "collapse",
      `data-target` = paste0("#", navContentId),
      `aria-controls` = navContentId,
      `aria-expanded` = "false",
      `aria-label` = "Toggle navigation",
      icon("bars")
    ),
    tags$div(
      class = "collapse navbar-collapse",
      id = navContentId,
      elems
    )
  )

  this <- attachDependencies(
    tagConcatAttributes(this, attrs),
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  this
}

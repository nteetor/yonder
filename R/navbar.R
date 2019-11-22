#' Navigation bar
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
#' @param collapse One of `"sm"`, `"md"`, `"lg"`, `"xl"`, or `NULL` specifying
#'   the breakpoint at which the navbar collaspes, defaults to `NULL`, in which
#'   case the navbar is always expanded.
#'
#' @family layout functions
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
#'       choices = c("Home", "About", "Our process")
#'     ) %>%
#'       margin(right = "auto"),
#'     formInput(
#'       inline = TRUE,
#'       id = "navForm",
#'       textInput(
#'         type = "search",
#'         id = "site_search",
#'         placeholder = "Search"
#'       ) %>%
#'         margin(right = c(sm = 2)),
#'       formSubmit(
#'         label = "Search",
#'         value = "search"
#'       ) %>%
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
navbar <- function(..., brand = NULL, collapse = NULL) {
  assert_possible(collapse, c("sm", "md", "lg", "xl"))

  dep_attach({
    args <- drop_nulls(list(...))

    items <- lapply(
      unnamed_values(args),
      function(item) {
        if (tag_class_re(item, "nav")) {
          item <- tag_class_add(item, "navbar-nav")
        } else if (tag_name_is(item, "form")) {
          if (!tag_class_re(item, "form-inline")) {
            warning("non-inline form element passed to `navbar()`", call. = FALSE)
          }
        } else if (!is_tag(item)) {
          item <- tags$span(class = "navbar-text", item)
        }

        item
      }
    )

    brand <- if (!is.null(brand)) {
      tags$a(
        class = "navbar-brand",
        href = "#",
        brand
      )
    }

    content_id <- generate_id("nav-content")

    component <- tags$nav(
      class = str_collate(
        "navbar",
        paste(c("navbar", "expand", collapse), collapse = "-"),
        "navbar-light"
      ),
      brand,
      tags$button(
        class = "navbar-toggler",
        type = "button",
        `data-toggle` = "collapse",
        `data-target` = paste0("#", content_id),
        `aria-controls` = content_id,
        `aria-expanded` = "false",
        `aria-label` = "Toggle navigation",
        tags$span(
          class = "navbar-toggler-icon"
        )
      ),
      tags$div(
        class = "collapse navbar-collapse",
        id = content_id,
        items
      )
    )

    tag_attributes_add(component, named_values(args))
  })
}

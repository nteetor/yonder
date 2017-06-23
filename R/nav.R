#' Page Navigation
#'
#' Create a nav.
#'
#' @param content A list of links, where links are constructed using `tags$a`.
#'
#'   To render a link in a disabled state name the corresponding list element(s)
#'   `disabled`, see examples below.
#'
#'   When building a tabbed interface with `nav` a default tab may be specified
#'   by naming an element `active`, see examples below.
#'
#' @param align Alignment of the nav, one of `"left"`, `"right"`, `"center"`, or
#'   `"horizontal"`, defaults to `"left"`.
#'
#' @param width Used to indicate the nav should fill the width of its parent
#'   element, one of `"fill"` or `"justify"`, defaults to `NULL`. If `"justify"`
#'   all nav links have equal width, when `"fill"` nav links are only equally
#'   spaced.
#'
#' @param column If `TRUE`, the nav is rendered as a horizontal stack instead
#'   of vertically, defaults to `FALSE`.
#'
#' @param tabs If `TRUE`, the nav is rendered as a set of tabs for a tabbed
#'   interface, defaults to `FALSE`. Specifying `TRUE` will also add a
#'   `data-toggle` HTML attribute to the nav links allowing them to toggle tabs.
#'
#' @param pills If `TRUE`, the nav is rendered as pills, defaults to `FALSE`.
#'
#' @details
#'
#' To center a horizontal nav specify `align = "horiztonal"` and `width =
#' "fill"` or `width = "justify"`.
#'
#'
#' @seealso
#'
#' For more information about the Bootstrap nav please follow this
#' [link](http://v4-alpha.getbootstrap.com/components/navs/).
#'
#' @examples
#' nav(
#'   list(
#'     tags$a(href = "#home", "Home"),
#'     tags$a(href = "#about", "About")
#'   )
#' )
#'
#' # active link
#' nav(
#'   list(
#'     active = tags$a(href = "#home", "Home"),
#'     tags$a(href = "#about", "About")
#'   )
#' )
#'
#' # active tab
#' nav(
#'   tabs = TRUE,
#'   list(
#'     active = tags$a(href = "#home", "Home"),
#'     tags$a(href = "#about", "About"),
#'     tags$a(href = "#blog", "Blog")
#'   )
#' )
#'
nav <- function(content = NULL, align = "left", width = NULL, column = FALSE,
                tabs = FALSE, pills = FALSE) {
  if (!(align %in% c("right", "left", "center"))) {
    stop('nav `align` must be "right", "left", or "center"', call. = FALSE)
  }

  tags$ul(
    class = collate(
      "nav",
      if (tabs) "nav-tabs",
      if (pills) "nav-pills",
      if (align == "right") "justify-content-end" else if (align == "center")
        "justify-content-center",
      if (column) "flex-colum"
    ),
    role = if (tabs) "tablist",
    lapply(
      seq_along(content),
      function(i) {
        tag <- content[[i]]
        name <- elodin(content[i])

        tag <- tagEnsureClass(tag, "nav-link")

        if (name == "active") {
          tag <- tagEnsureClass(tag, "active")
        }

        if (name == "disabled") {
          tag <- tagEnsureClass(tag, "disabled")
        }

        if (tabs) {
          tag$attribs$`data-toggle` <- "tab"
          tag$attribs$role <- "tab"
        }

        tags$li(
          class = "nav-item",
          tag
        )
      }
    ),
    bootstrap()
  )
}


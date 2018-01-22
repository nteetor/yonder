#' Page Navigation
#'
#' Create a nav. The nav may be styled as the default links, tabs, or pills. To
#' create dynamic tabbed content see [tabContent].
#'
#' @param labels A character vector specifying the labels of the nav links.
#'
#' @param hrefs A character vector specifying the hrefs of the nav links.
#'
#' @param active One of `labels` specifying which nav link is active by default,
#'   defaults to `NULL`, in which case there is no active tab.
#'
#' @param ... Additional named arguments to pass as HTML attributes to the
#'   parent element.
#'
#' @seealso
#'
#' Bootstrap 4 nav documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/navs/}
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       nav(c("Link", "Link", "Link"), character(3)) %>%
#'         div() %>%
#'         border() %>%
#'         margins(2),
#'       nav(c("Link", "Link", "Link")) %>%
#'         direction("column") %>%
#'         div() %>%
#'         border() %>%
#'         margins(2),
#'       nav(c("Link", "Link", "Link"), style = "tabs") %>%
#'         div() %>%
#'         border() %>%
#'         padding(2) %>%
#'         margins(2),
#'       nav(c("Link", "Link", "Link"), style = "pills") %>%
#'         div() %>%
#'         border() %>%
#'         padding(2) %>%
#'         margins(2),
#'       nav(c("Link", "Link", "Link"), style = "pills") %>%
#'         content("center") %>%
#'         div() %>%
#'         border() %>%
#'         padding(2) %>%
#'         margins(2),
#'       nav(c("Link", "Link", "Link"), style = "pills") %>%
#'         content("end") %>%
#'         div() %>%
#'         border() %>%
#'         padding(2) %>%
#'         margins(2),
#'       nav(c("Link", "Link", "Link"), style = "pills") %>%
#'         direction("column") %>%
#'         div() %>%
#'         display("flex") %>%
#'         content("end") %>%
#'         border() %>%
#'         padding(2) %>%
#'         margins(2),
#'       nav(c("Link", "Link", "Link"), style = "fill") %>%
#'         div() %>%
#'         border() %>%
#'         padding(2) %>%
#'         margins(2)
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
#'
nav <- function(labels, hrefs = NULL, active = NULL, style = "links", ...) {
  if (!is.null(hrefs) && length(labels) != length(hrefs)) {
    stop(
      "invalid `nav` argument, `hrefs` must be the same length as `labels`",
      call. = FALSE
    )
  }

  if (!re(style, "links|tabs|pills|fill", len0 = FALSE)) {
    stop(
      "invalid `nav` argument, `style` must be one of ",
      '"links", "tabs", or "pills"',
      call. = FALSE
    )
  }

  hrefs <- hrefs %||% rep.int("#", length(labels))

  tags$ul(
    class = collate(
      "nav",
      if (style == "fill") {
        c("nav-pills", "nav-fill")
      } else if (style != "links") {
        paste0("nav-", style)
      }
    ),
    Map(
      label = labels,
      href = hrefs,
      function(label, href) {
        tags$li(
          class = "nav-item",
          tags$a(
            class = "nav-link",
            href = href,
            label
          )
        )
      }
    ),
    ...,
    bootstrap()
  )
}

#' Create dynamic tabbed content
#'
#' Create tabbable content stylized as tabs, horizontal pills, or vertical
#' pills. Tab sets or tab panels are distinct from navs.
#'
#' @param nav A `nav()` element.
#'
#' @param ... Any number of `tabPane`s or named attributes passed as HTML
#'   attributes to the parent element.
#'
#' @param fade One of `TRUE` or `FALSE`, if `TRUE` the tab pane fades in,
#'   defaults to `TRUE`.
#'
#' @details
#'
#' To know which tab is active check the reactive value of the nav.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tabbableContent(
#'             nav = nav(
#'               id = "tabs",
#'               labels = c("One", "Two", "Three"),
#'               style = "tabs"
#'             ) %>%
#'               margins(c(0, 0, 3, 0)),
#'             tabPane(
#'               "A tab"
#'             ),
#'             tabPane(
#'               "Another tab"
#'             ),
#'             tabPane(
#'               "A final tab"
#'             )
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("which")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$which <- renderPrint({
#'         input$tabs
#'       })
#'     }
#'   )
#' }
#'
tabbableContent <- function(nav, ...) {
  if (!tagHasClass(nav, "nav") && !tagIs(nav, "ul")) {
    stop(
      "invalid `tabbableContent` argument, expecting `nav` to be a call to ",
      "`nav()`, see ?nav",
      call. = FALSE
    )
  }

  args <- list(...)
  attrs <- attribs(args)
  elems <- elements(args)

  isPane <- vapply(elems, tagHasClass, logical(1), class = "tab-pane")
  panes <- elems[isPane]
  other <- elems[!isPane]

  if (length(panes) != length(nav$children[[1]])) {
    stop("expecting same number of nav elements as panes")
  }

  tabIds <- ID(rep.int("tab", length(panes)))
  paneIds <- ID(rep.int("pane", length(panes)))

  #
  # panes
  #
  for (i in seq_along(panes)) {
    if ("id" %in% names(panes[[i]]$attribs)) {
      paneIds[[i]] <- panes[[i]]$attribs$id
    } else {
      panes[[i]]$attribs$id <- paneIds[[i]]
    }

    panes[[i]]$attribs$`aria-labelledby` <- tabIds[[i]]
  }

  panes[[1]] <- tagEnsureClass(panes[[1]], "show")
  panes[[1]] <- tagEnsureClass(panes[[1]], "active")

  #
  # tabs (nav)
  #
  for (i in seq_along(nav$children[[1]])) {
    attrs <- nav$children[[1]][[i]]$children[[1]]$attribs

    attrs$id <- tabIds[[i]]
    attrs$href <- paste0("#", paneIds[[i]])
    attrs$`data-toggle` <- "tab"
    attrs$`aria-controls` <- paneIds[[i]]

    nav$children[[1]][[i]]$children[[1]]$attribs <- attrs
  }

  nav$children[[1]][[1]]$children[[1]] <- tagEnsureClass(
    nav$children[[1]][[1]]$children[[1]],
    "active"
  )

  nav$attribs$id <- id
  nav$attribs$role <- "tablist"

  tagConcatAttributes(
    tags$div(
      nav,
      tags$div(
        class = "tab-content",
        other,
        panes
      ),
      bootstrap()
    ),
    attrs
  )
}

#' @rdname tabbableContent
#' @export
tabPane <- function(..., fade = TRUE) {
  tags$div(
    class = collate(
      "tab-pane",
      if (fade) "fade"
    ),
    role = "tabpanel",
    ...
  )
}

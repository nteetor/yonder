#' Page Navigation
#'
#' Create a nav. The nav may be styled as the default links, tabs, or pills. To
#' create dynamic tabbed content see [tabContent].
#'
#' @param labels A character vector specifying the labels of the nav links.
#'
#' @param hrefs A character vector specifying the hrefs of the nav links.
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
#' @param id A character string specifying the id of the tabbed content. The
#'   reactive value of tabbed content is the label of the currently selected tab
#'   or a custom value if `values` is not `NULL`.
#'
#' @param labels A character vector of labels, one for each tab panel.
#'
#' @param ... Any number of `tabPanel`'s or named attributes passed as HTML
#'   attributes to the parent element.
#'
#' @param style One of `"tabs"`, `"pills"`, or `"vertical"` specifying the
#'   visual style of the tabs, defaults to `"tabs"`.
#'
#' @param selected One of `labels` specifying which tab is selected by default,
#'   defaults to `NULL`, in which case the first tab is selected by default.
#'
#' @param values A character vector specifying the possible values of the tabs,
#'   defaults to `labels`. The reactive value of the tabbed content is the
#'   corresponding value of the active tab. Values are matched to tabs by
#'   position.
#'
#' @param ids A character vector of ids to use for each tab, defaults to `NULL`
#'   in which case ids will be generated.
#'
#' @param fade One of `TRUE` or `FALSE`, if `TRUE` the tab pane fades in,
#'   defaults to `TRUE`.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           default = 3,
#'           tabContent(
#'             id = "tabs",
#'             labels = c("Hello", "Goodnight"),
#'             tabPanel(
#'               d4("World")
#'             ),
#'             tabPanel(
#'               d4("Moon")
#'             )
#'           )
#'         ),
#'         col(
#'           default = 3,
#'           tabContent(
#'             id = "pills",
#'             style = "pills",
#'             labels = c("One", "Red"),
#'             tabPanel(
#'               d4("fish, two fish")
#'             ),
#'             tabPanel(
#'               d4("fish, blue fish")
#'             )
#'           )
#'         ),
#'         col(
#'           tabContent(
#'             id = "vert",
#'             style = "vertical",
#'             labels = c("How", "Brown"),
#'             tabPanel(
#'               d4("now")
#'             ),
#'             tabPanel(
#'               d4("cow")
#'             )
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tabContent(
#'             id = "tabs",
#'             labels = c("One", "Two", "Three"),
#'             values = c("first tab", "second tab", "third tab"),
#'             tabPanel(
#'               "A tab"
#'             ),
#'             tabPanel(
#'               "Another tab"
#'             ),
#'             tabPanel(
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
tabContent <- function(id, labels, ..., style = "tabs", selected = NULL,
                       values = labels, ids = NULL) {
  if (!re(style, "tabs|pills|vertical", len0 = NULL)) {
    stop(
      "invalid `tabContent` argument, `style` must be one of",
      '"tabs", "pills", or "vertical"',
      call. = FALSE
    )
  }

  args <- list(...)
  eles <- elements(args)
  attrs <- attribs(args)

  if (length(eles) != length(labels)) {
    stop(
      "invalid `tabContent` argument, `labels` must be the same length",
      "as the number of tab panels",
      call. = FALSE
    )
  }

  if (!is.null(values) && (length(values) != length(eles))) {
    stop(
      "inavlid `tabContent` argument, if `values` is not NULL, a value must",
      "be specified for each tab panel",
      call. = FALSE
    )
  }

  if (!is.null(ids) && (length(ids) != length(eles))) {
    stop(
      "invalid `tabContent` argument, if `ids` is not NULL, an id must be",
      "specified for each tab panel",
      call. = FALSE
    )
  }

  ids <- ids %||% ID(rep.int("tab", length(eles)))
  selected <- match2(selected %||% labels[[1]], labels)
  values <- values %||% labels

  tabs <- tags$ul(
    class = collate(
      "nav",
      paste0("nav-", if (style == "vertical") "pills" else style),
      if (style == "vertical") "flex-column"
    ),
    role = "tablist",
    Map(
      id = ids,
      label = labels,
      active = selected,
      value = values,
      f = function(id, label, active, value) {
        tags$li(
          class = "nav-item",
          tags$a(
            class = collate(
              "nav-link",
              if (active) "active"
            ),
            `data-toggle` = "tab",
            href = paste0("#", id),
            role = "tab",
            `aria-controls` = id,
            `aria-selected` = if (active) "true" else "false",
            `data-value` = if (!is.null(values)) value,
            label
          )
        )
      }
    )
  )

  tabs <- tagConcatAttributes(tabs, attrs)

  panes <- tags$div(
    class = "tab-content",
    Map(
      id = ids,
      pane = eles,
      active = selected,
      f = function(id, pane, active) {
        if (active) {
          pane <- tagEnsureClass(pane, "show")
          pane <- tagEnsureClass(pane, "active")
        }

        pane$attribs$id <- id

        pane
      }
    )
  )

  if (style == "vertical") {
    tabs <- col(default = 3, tabs)
    panes <- col(default = 9, panes)
  }

  parent <- if (style == "vertical") row else tags$div

  parent(
    id = id,
    class = "dull-tabs",
    tabs,
    panes,
    bootstrap()
  )
}

#' @rdname tabContent
#' @export
tabPanel <- function(..., fade = TRUE) {
  tags$div(
    class = collate(
      "tab-pane",
      if (fade) "fade"
    ),
    role = "tabpanel",
    ...
  )
}

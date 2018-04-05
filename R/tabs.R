#' Tab list
#'
#' Create a set of tabs for controlling tab content. Tab lists are separated
#' from tab content or tab panes for flexible placement, see the example below
#' combining cards and tabs. Because of this separation it is important to
#' remember a tab list does very little alone. Be sure to add corresponding
#' [tab panes][tabPane].
#'
#' @param id A character string specifying the id of the tab list, this
#'   value must also be passed to [tabContent()] as the `list` argument.
#'
#'   Tabs have a reactive value which is by default is the label of the open
#'   tab. For custom values see `values`.
#'
#' @param labels A character vector specifying the labels of the tabs.
#'
#' @param values A character vector specifying a reactive value for each tab,
#'   defaults to `labels`.
#'
#' @param active One of `values` specifying which tab is initially shown,
#'   defaults to `values[1]`.`
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @family tabs
#' @export
#' @examples
#'
#' tabList(
#'   labels = c("Home", "About", "Posts"),
#'   values = c("home", "about", "blog")
#' )
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       card(
#'         header = tabList(
#'           id = "tabs",
#'           labels = c("Home", "Profile", "Contact"),
#'         ),
#'         tabContent(
#'           list = "tabs",
#'           tabPane(
#'             "Vestibulum id ligula porta felis euismod semper. Cras justo
#'              odio, dapibus ac facilisis in, egestas eget quam."
#'           ),
#'           tabPane(
#'             "Duis mollis, est non commodo luctus, nisi erat porttitor ligula,
#'              eget lacinia odio sem nec elit. Aenean eu leo quam. Pellentesque
#'              ornare sem lacinia quam venenatis vestibulum."
#'           ),
#'           tabPane(
#'             "Donec ullamcorper nulla non metus auctor fringilla. Nullam id
#'              dolor id nibh ultricies vehicula ut id elit."
#'           )
#'         )
#'       ) %>%
#'         margins(4) %>%
#'         width(50)
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         showAlert(input$tabs, duration = 2, color = "grey")
#'       })
#'     }
#'   )
#' }

tabList <- function(id, labels, values = labels, active = values[1], ...) {
  if (length(labels) == 0) {
    stop(
      "invalid `tabList()` argument, `labels` must contain at least one ",
      "character string",
      call = FALSE
    )
  }

  if (!all(is.character(labels))) {
    stop(
      "invalid `tabList()` argument, `labels` must be a character vector",
      call. = FALSE
    )
  }

  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `tabList()` argument, `id` must be a character string or ",
      "NULL",
      call. = FALSE
    )
  }

  if (!is.null(active)) {
    if (length(active) > 1) {
      stop(
        "invalid `tabList()` argument, `active` must be a single character ",
        "string",
        call. = FALSE
      )
    }

    if (!(active %in% values)) {
      stop(
        "invalid `tabList()` argument, `active` must be one of `values`",
        call. = FALSE
      )
    }
  }

  active <- match2(active, values)

  tags$ul(
    class = "dull-tabs-input nav nav-tabs",
    role = "tablist",
    id = id,
    ...,
    Map(
      label = labels,
      value = values,
      active = active,
      function(label, value, active) {
        tags$li(
          class = "nav-item",
          tags$a(
            class = collate(
              "nav-link",
              if (active) "active"
            ),
            `data-toggle` = "tab",
            `data-value` = value,
            `aria-selected` = if (active) "true" else "false",
            label
          )
        )
      }
    )
  )
}

#' Tab content, panes
#'
#' Create tabbed content. You will need to create a tab pane for each of the
#' tabs in the corresponding tab list. A tab list and tab content are linked
#' through the `id` argument and `list` argument respectively.
#'
#' @param list A character string specifying the id of a tab list, see `id`
#'   in [tabList()].
#'
#' @param ... For **tabContent**, calls to `tabPane` or named arguments passed
#'   as HTML attributes to the parent element.
#'
#'   For **tabPane**, any number of tag elements or named arguments passed as
#'   HTML attributes to the parent element.
#'
#' @family tabs
#' @export
#' @examples
#'
#' tabContent(
#'   list = "tabListId",
#'   tabPane(
#'     tags$h1("Pane 1"),
#'     tags$p("Lorem Dapibus Malesuada Cras Cursus")
#'   ),
#'   tabPane(
#'     tags$p("Pane 2"),
#'     tags$p("Magna Aenean Mattis Ultricies Ridiculus")
#'   )
#' )
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           default = 4,
#'           card(
#'             p("Nullam quis risus eget urna mollis ornare vel eu leo. Nullam
#'             id dolor id nibh ultricies vehicula ut id elit.")
#'           ) %>%
#'             background("grey", +2)
#'         ),
#'         col(
#'           tabList(
#'             id = "myTabs",
#'             labels = c("Home", "About", "Posts")
#'           ) %>%
#'             margins(c(0, 0, 5, 0)),
#'           tabContent(
#'             list = "myTabs",
#'             tabPane(
#'               h4("This is home."),
#'               p("Pellentesque dapibus suscipit ligula.  Donec ",
#'                 "posuere augue in quam.  Etiam vel tortor ",
#'                 "sodales tellus ultricies commodo.  Suspendisse ",
#'                 "potenti.  Aenean in sem ac leo mollis blandit."),
#'               p("Donec neque quam, dignissim in, mollis nec, ",
#'                 "sagittis eu, wisi.  Phasellus lacus.  Etiam ",
#'                 "laoreet quam sed arcu.  Phasellus at dui in ligula",
#'                 "mollis ultricies.  Integer placerat tristique nisl.")
#'             ),
#'             tabPane(
#'               h4("All about."),
#'               p("Pellentesque dapibus suscipit ligula. ",
#'                 "Phasellus neque orci, porta a, aliquet quis, semper a, massa. ",
#'                 "Nullam tristique diam non turpis. ",
#'                 "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.")
#'             ),
#'             tabPane(
#'               h4("Blog items."),
#'               p("Nullam tempus.  Mauris ac felis vel velit ",
#'                 "tristique imperdiet.  Donec at pede.  Etiam vel ",
#'                 "neque nec dui dignissim bibendum.  Vivamus id ",
#'                 "enim.  Phasellus neque orci, porta a, aliquet ",
#'                 "quis, semper a, massa.  Phasellus purus.")
#'             )
#'           )
#'         )
#'       ) %>%
#'         padding(3)
#'     ),
#'     server = function(input, output) {
#'     }
#'   )
#' }
#'
tabContent <- function(list, ...) {
  tags$div(
    class = "tab-content",
    `data-tablist` = list,
    ...
  )
}

#' @family tabs
#' @rdname tabContent
#' @export
#'
tabPane <- function(...) {
  tags$div(
    class = "tab-pane fade",
    role = "tab-panel",
    ...
  )
}

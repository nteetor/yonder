#' Tab list
#'
#' Create a tab list for controlling tab content.
#'
#' @param labels A character vector specifying the labels of the tabs.
#'
#' @param panes A character vector specifying the ids of the tab panes
#'   controlled by the tab list, see `id` in [tabPane].
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
#' @param id A character string specifying a reactive id for the tab list,
#'   defaults to `NULL`, in which case a reactive value is not created. If *not*
#'   `NULL` the tab lists's reactive value is the value of the active tab.
#'
#' @family tabs
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       card(
#'         header = tabList(
#'           labels = c("Home", "Profile", "Contact"),
#'           panes = c("homePane", "profPane", "contactPane"),
#'         ),
#'         tabContent(
#'           tabPane(
#'             id = "homePane",
#'             class = "show active",
#'             "Vestibulum id ligula porta felis euismod semper. Cras justo
#'              odio, dapibus ac facilisis in, egestas eget quam."
#'           ),
#'           tabPane(
#'             id = "profPane",
#'             "Duis mollis, est non commodo luctus, nisi erat porttitor ligula,
#'              eget lacinia odio sem nec elit. Aenean eu leo quam. Pellentesque
#'              ornare sem lacinia quam venenatis vestibulum."
#'           ),
#'           tabPane(
#'             id = "contactPane",
#'             "Donec ullamcorper nulla non metus auctor fringilla. Nullam id
#'              dolor id nibh ultricies vehicula ut id elit."
#'           )
#'         )
#'       ) %>%
#'         margins(4) %>%
#'         width(50)
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
tabList <- function(labels, panes, values = labels, active = values[1], ...,
                    id = NULL) {
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
    class = "nav nav-tabs",
    role = "tablist",
    id = id,
    ...,
    Map(
      label = labels,
      pane = panes,
      value = values,
      active = active,
      function(label, pane, value, active) {
        tags$li(
          class = "nav-item",
          tags$a(
            class = collate(
              "nav-link",
              if (active) "active"
            ),
            `data-toggle` = "tab",
            href = paste0("#", pane),
            `aria-controls` = pane,
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
#' Create tabbed content.
#'
#' @param ... For **tabContent***, calls to `tabPane` or named arguments passed
#'   as HTML attributes to the parent element.
#'
#'   For **tabPane**, any number of tag elements or named arguments passed as
#'   HTML attributes to the parent element.
#'
#' @param id A character string specifying the id of the tab pane, this id
#'   must be passed to a tab list, see **panes** in [tabList].
#'
#' @family tabs
#' @export
#' @examples
#'
tabContent <- function(...) {
  tags$div(
    class = "tab-content",
    ...
  )
}

#' @family tabs
#' @rdname tabContent
#' @export
#'
tabPane <- function(id, ...) {
  tags$div(
    class = "tab-pane fade",
    ...
  )
}

#' List Group
#'
#' A way of handling and outlining content as a list.
#'
#' @param ... List items, built with `listItem`, character strings, custom HTML
#'   content, or named arguments passed as HTML attributes to the parent `div`.
#'
#' @param label List item label, defaults to `NULL`.
#'
#' @param value The value of the list item, defaults to `NULL`.
#'
#' @param context A character string specifying the visual context of the list
#'   item, one of `"success"`, `"info"`, `"warning"`, or `"danger"`, defaults to
#'   `NULL`.
#'
#' @param active If `TRUE` the list item is rendered in the active state,
#'   defaults to `FALSE`.
#'
#' @param disabled If `TRUE` the list item is rendered in the disabled state,
#'   disabled items do not receive click events, defaults to `FALSE`.
#'
#' @param hover If `TRUE` the list item receives additional hover animation,
#'   under the hood the list item is a `<a>` element instead of `<li>`, defaults
#'   to `FALSE`.
#'
#' @param badge A [`badge`] which is right aligned inside the list item, see
#'   [`renderBadge`] for more on how to work with badges, defaults to `NULL`.
#'
#' @details
#'
#' Character strings are converted into list items. Custom tags are left as is
#' and must include Bootstrap classes ahead of time. To specify a value for a
#' list item please include a `data-value` attribute in the `.list-group-item`
#' element.
#'
#' @seealso
#'
#' For more information on Bootstrap list groups please refer to the
#' [reference page](https://v4-alpha.getbootstrap.com/components/list-group/).
#'
#' @export
#' @examples
#' listGroup(
#'   "Item 1",
#'   "Item 2",
#'   "Item 3"
#' )
#'
#' # highlight list item
#' listGroup(
#'   "Item 1",
#'   listItem("Item 2", active = TRUE),
#'   "Item 3"
#' )
#'
#' # disable list items
#' listGroup(
#'   listItem("Item 1", disabled = TRUE),
#'   "Item 2",
#'   listItem("Item 3", disabled = TRUE)
#' )
#'
#' # HTML list items
#' listGroup(
#'   tags$h4(class = "list-group-item", "Heading 1"),
#'   tags$h4(class = "list-group-item", "Heading 2"),
#'   tags$h4(class = "list-group-item", "Heading 3")
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(ggplot2)
#'
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           width = 4,
#'           tags$h4("Any preferences?"),
#'           listGroup(
#'             id = "preferences",
#'             listItem("No heights", "noheights"),
#'             listItem("No animals", "noanimals")
#'           )
#'         ),
#'         col(
#'           tags$h4("Possible outings"),
#'           listGroup(
#'             listItem(
#'               id = "optZoo",
#'               "Zoo visit!"
#'             ),
#'             listItem(
#'               id = "optSkydive",
#'               "Sky diving!"
#'             ),
#'             listItem(
#'               id = "optPern",
#'               "Visit Pern"
#'             )
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         if ("noheights" %in% input$preferences) {
#'           updateListItem("optSkydive", context = "warning")
#'         }
#'       })
#'
#'     }
#'   )
#' }
#'
listGroup <- function(...) {
  args <- list(...)
  attrs <- args[elodin(args) != ""]
  content <- args[elodin(args) == ""]

  lg <- tags$ul(
    class = "dull-list-group list-group list-group-flush",
    lapply(
      content,
      function(el) if (is_tag(el)) el else listItem(el, value = el)
    ),
    bootstrap()
  )

  lg$attribs <- c(lg$attribs, attrs)
  lg
}

#' @rdname listGroup
#' @export
listItem <- function(label = NULL, value = NULL, context = NULL, active = FALSE,
                     disabled = FALSE, hover = FALSE, badge = NULL, ...) {
  if (bad_context(context)) {
    stop(
      '`listItem` argument `context` must be one of "success", "info", ',
      '"warning" and "danger"', call. = FALSE
      )
  }

  item <- tags$li(
    class = collate(
      "dull-list-group-item",
      "list-group-item",
      if (hover) "list-group-item-action",
      if (!is.null(context)) paste0("list-group-item-", context),
      if (active) "active",
      if (disabled) "disabled",
      if (!is.null(badge)) "justify-content-between"
    ),
    `data-value` = value,
    label,
    badge,
    ...
  )

  if (hover) {
    item$name <- "a"
  }

  item
}

updateListItem <- function(id, label = NULL, value = NULL, context = NULL,
                           active = NULL, disabled = NULL,
                           session = getDefaultReactiveDomain()) {
  if (bad_context(context)) {
    stop(
      '`updateListItem` argument `context` must be one of "success", "info", ',
      '"warning" and "danger"', call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      label = label,
      value = value,
      context = if (!is.null(context)) paste0("list-group-item-", context),
      active = active,
      disabled = disabled
    )
  )
}

# renderListItem <- function(label = )

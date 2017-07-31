#' List group inputs
#'
#' A way of handling and outlining content as a list. List groups function
#' similarly to checkbox groups. A list group returns a reactive vector of the
#' values from its active (selected) list group items. List group items are
#' selected or unselected by clicking on them. While list groups may be used as
#' reactive inputs they may also be used to simply display content, in which
#' case do not specify a list group id.
#'
#' @param id A character string specifying the id of the list group or list
#'   group item, defaults to `NULL`.
#'
#'   If a **list group** id is specified then a reactive value is available to
#'   the shiny server.
#'
#'   Specifying a **list group item** id is only necessary to use
#'   `updateListGroupItem`.
#'
#' @param ... List group items or named arguments passed as HTML attributes to
#'   the parent element.
#'
#' @param label A character string specifying the label of the list group item,
#'   defaults to `NULL`.
#'
#' @param value A character string specifying the value of the list group item,
#'   defaults to `NULL`.
#'
#' @param context A character string specifying the visual context of the list
#'   group item, one of `"success"`, `"info"`, `"warning"`, or `"danger"`,
#'   defaults to `NULL`. Use `"none"` to remove a list group item's context with
#'   `updateListGroupItem`.
#'
#' @param active If `TRUE` the list group item is rendered in an active state,
#'   defaults to `FALSE`.
#'
#' @param disabled If `TRUE` the list group item is rendered in a disabled
#'   state, a disabled list group item will not receive click events, defaults
#'   to `FALSE`. A list group item may be enabled using `updateListGroupItem`.
#'
#' @param badge A `badgeOutput` which is right aligned inside the list group
#'   item, see [`renderBadge`] for more on how to work with badges, defaults to
#'   `NULL`.
#'
#' @seealso
#'
#' For more information on Bootstrap list groups please refer to the
#' [reference page](https://v4-alpha.getbootstrap.com/components/list-group/).
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         tags$h3("Find something to do!"),
#'         br()
#'       ),
#'       row(
#'         col(
#'           width = 4,
#'           tags$h4("Any preferences?"),
#'           listGroupInput(
#'             id = "preferences",
#'             listGroupItem(
#'               label = "No heights",
#'               value = "noheights"
#'             ),
#'             listGroupItem(
#'               label = "No animals",
#'               value = "noanimals"
#'             )
#'           )
#'         ),
#'         col(
#'           tags$h4("Possible outings"),
#'           listGroupInput(
#'             hover = FALSE,
#'             listGroupItem(
#'               id = "optZoo",
#'               "Zoo visit!"
#'             ),
#'             listGroupItem(
#'               id = "optSkydive",
#'               "Sky diving!"
#'             ),
#'             listGroupItem(
#'               id = "optPern",
#'               "Visit Pern"
#'             )
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         prefs <- input$preferences
#'
#'         updateListGroupItem(
#'           id = "optSkydive",
#'           context = if ("noheights" %in% prefs) "danger" else "none"
#'         )
#'
#'         updateListGroupItem(
#'           id = "optZoo",
#'           context = if ("noanimals" %in% prefs) "danger" else "none"
#'         )
#'
#'         updateListGroupItem(
#'           id = "optPern",
#'           context = if ("noanimals" %in% prefs) "danger" else "none"
#'         )
#'       })
#'     }
#'   )
#' }
#'
listGroupInput <- function(..., id = NULL) {
  tags$ul(
    class = collate(
      "dull-list-group-input",
      "list-group",
      "list-group-flush"
    ),
    ...,
    id = id,
    bootstrap()
  )
}

#' @rdname listGroupInput
#' @export
listGroupItem <- function(label = NULL, value = NULL, context = NULL,
                          active = FALSE, disabled = FALSE, badge = NULL, ...,
                          id = NULL) {
  if (bad_context(context)) {
    stop(
      '`listGroupItem` argument `context` must be one of "success", "info", ',
      '"warning" and "danger"', call. = FALSE
      )
  }

  tags$button(
    class = collate(
      "dull-list-group-item",
      "list-group-item",
      "list-group-item-action",
      if (!is.null(context)) paste0("list-group-item-", context),
      if (active) "active",
      if (!is.null(badge)) "justify-content-between"
    ),
    `data-value` = value,
    disabled = if (disabled) NA,
    label,
    badge,
    ...,
    id = id,
    bootstrap()
  )
}

#' @rdname listGroupInput
#' @export
updateListGroupItem <- function(id, context = NULL, active = NULL,
                                disable = NULL,
                                session = getDefaultReactiveDomain()) {
  if (!re(context, "none|success|info|warning|danger")) {
    stop(
      "`invalid `updateListGroupItem` argument, `context` must be one of ",
      '"success", "info", "warning", "danger", or "none"',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      context = context, #if (!is.null(context)) paste0("list-group-item-", context),
      active = active,
      disable = disable
    )
  )
}

#' Collapsible sections
#'
#' The `collapsible()` function wraps a tag element in a collasible div
#' element. The state of the element, shown or hidden, is toggled using
#' `hideCollapse()`, `showCollapse()`, and `toggleCollapse()`.
#'
#' @param id A character string specifying the id of the collapsible pane. Pass
#'   this id to the `hideCollapse()`, `showCollapse()`, or `toggleCollapse()`
#'   to change the state of a collapsible pane.
#'
#' @param show One of `TRUE` or `FALSE` specifying if the collapsible pane
#'   is shown when the page renders, defaults to `FALSE`.
#'
#' @param ... Tag elements inside the collapsible pane or additional named
#'   arguments passed as HTML attributes to parent element.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @details
#'
#' Padding may not be applied to the collapsible pane div element. To pad a
#' collapsible pane first wrap the pane in another element and add padding to
#' this new element.
#'
#' @section App with collapse:
#'
#' ```R
#' ui <- container(
#'   buttonInput(
#'     id = "demo",
#'     label = "Toggle collapse"
#'   ),
#'   collapsiblePane(
#'     id = "collapse",
#'     p(
#'       "Pellentesque condimentum, magna ut suscipit hendrerit, ",
#'       "ipsum augue ornare nulla, non luctus diam neque sit amet urna."
#'     ),
#'     p(
#'       "Praesent fermentum tempor tellus.  Vestibulum convallis, ",
#'       "lorem a tempus semper, dui dui euismod elit, vitae placerat ",
#'       "urna tortor vitae lacus."
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$demo, {
#'     togglePane("collapse")
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family content
#' @export
#' @examples
#'
#' ### Examples
#'
#' # As these are server-side utilities, please run the example applications
#' # above.
#'
collapsiblePane <- function(id, ..., show = FALSE) {
  if (!is.character(id)) {
    stop(
      "inavlid `collapsiblePane()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  pane <- tags$div(
    id = id,
    class = collate(
      "collapse",
      if (show) "show"
    ),
    ...
  )

  pane <- attachDependencies(pane, c(yonderDep(), bootstrapDep()))

  pane
}

#' @rdname collapsiblePane
#' @export
collapsePane <- function(id, session = getDefaultReactiveDomain()) {
  sendCollapseMessage("hide", id, session)
}

#' @rdname collapsiblePane
#' @export
expandPane <- function(id, session = getDefaultReactiveDomain()) {
  sendCollapseMessage("show", id, session)
}

#' @rdname collapsiblePane
#' @export
togglePane <- function(id, session = getDefaultReactiveDomain()) {
  sendCollapseMessage("toggle", id, session)
}

# internal
sendCollapseMessage <- function(type, id, session) {
  if (is.null(session)) {
    stop(
      "`", sys.call(-1)[[1]], "()`, must be called within a reactive context",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:collapse", list(
    type = type,
    data = list(
      target = id
    )
  ))
}

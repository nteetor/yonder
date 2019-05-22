#' Collapsible panes
#'
#' The `collapsePane()` creates a collapsible container. The state of the
#' container, expanded or collapsed, is toggled using `showCollapsePane()`,
#' `hideCollapsePane()`, and `toggleCollapsePane()`.
#'
#' @param id A character string specifying the id of the collapse pane.
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
#'   collapsePane(
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
#'     toggleCollapsePane("collapse")
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family components
#' @export
#' @examples
#'
#' ### Examples
#'
#' # As these are server-side utilities, please run the example applications
#' # above.
#'
collapsePane <- function(id, ..., show = FALSE) {
  assert_id()

  pane <- tags$div(
    id = id,
    class = str_collate(
      "collapse",
      if (show) "show"
    ),
    ...
  )

  attach_dependencies(pane)
}

#' @rdname collapsePane
#' @export
hideCollapsePane <- function(id, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:collapse", list(
    type = "hide",
    data = list(
      target = id
    )
  ))
}

#' @rdname collapsePane
#' @export
showCollapsePane <- function(id, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:collapse", list(
    type = "show",
    data = list(
      target = id
    )
  ))
}

#' @rdname collapsePane
#' @export
toggleCollapsePane <- function(id, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:collapse", list(
    type = "toggle",
    data = list(
      target = id
    )
  ))
}

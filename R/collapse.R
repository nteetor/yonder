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
#' @inheritParams elementOutput
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

#' @rdname collapsiblePane
#' @export
collapsePane <- function(id, session = getDefaultReactiveDomain()) {
  assert_session()

  session$sendCustomMessage("yonder:collapse", list(
    type = "hide",
    data = list(
      target = id
    )
  ))
}

#' @rdname collapsiblePane
#' @export
expandPane <- function(id, session = getDefaultReactiveDomain()) {
  assert_session()

  session$sendCustomMessage("yonder:collapse", list(
    type = "show",
    data = list(
      target = id
    )
  ))
}

#' @rdname collapsiblePane
#' @export
togglePane <- function(id, session = getDefaultReactiveDomain()) {
  assert_session()

  session$sendCustomMessage("yonder:collapse", list(
    type = "toggle",
    data = list(
      target = id
    )
  ))
}

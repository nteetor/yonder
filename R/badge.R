#' Badges
#'
#' Small highlighted content which scales to its parent's size. A badge may
#' be dynamically updated with [replaceElement()].
#'
#' @inheritParams outputElement
#'
#' @param ... Named arguments passed as HTML attributes to the parent
#'   element or tag elements passed as children to the parent element.
#'
#' @details
#'
#' Use [replaceElement()] and [removeElement()] to modify the contents of a
#' badge.
#'
#' @section Example application:
#'
#' ```
#' ui <- container(
#'   buttonInput(
#'     id = "clicker",
#'     label = list(
#'       "Clicks",
#'       badgeElement("counter") %>%
#'         margin(left = 2) %>%
#'         background("teal")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   observe({
#'     clicks <- if (is.null(input$clicker)) 0 else input$clicker
#'     replaceElement("counter", clicks)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ````
#'
#' @family rendering
#' @export
#' @examples
#'
#' ### Possible colors
#'
#' colors <- c(
#'   "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'   "yellow", "amber", "orange", "grey", "white"
#' )
#'
#' div(
#'   lapply(colors, function(color) {
#'     badgeElement(color, color) %>%
#'       background(color) %>%
#'       margin(2) %>%
#'       padding(1)
#'   })
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
badgeElement <- function(id, ...) {
  assert_id()

  component <- tags$span(
    class = "yonder-element badge",
    id = id,
    ...
  )

  attach_dependencies(component)
}

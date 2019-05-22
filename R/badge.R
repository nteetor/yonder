#' Badges
#'
#' Small highlighted content which scales to its parent's size. A badge may
#' be dynamically updated with [replaceContent()], in which case be sure to
#' pass an `id` argument as part of `...`.
#'
#' @param ... Named arguments passed as HTML attributes to the parent
#'   element or tag elements passed as children to the parent element.
#'
#' @section Example application:
#'
#' ```
#' ui <- container(
#'   buttonInput(
#'     id = "clicker",
#'     label = list(
#'       "Clicks",
#'       badge(id = "counter") %>%
#'         margin(left = 2) %>%
#'         background("teal")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   observe({
#'     clicks <- if (is.null(input$clicker)) 0 else input$clicker
#'     replaceContent("counter", clicks)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ````
#'
#' @family components
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
#'     badge(color) %>%
#'       background(color) %>%
#'       margin(2) %>%
#'       padding(1)
#'   })
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
badge <- function(...) {
  attach_dependencies(
    tags$span(
      class = "badge",
      ...
    )
  )
}

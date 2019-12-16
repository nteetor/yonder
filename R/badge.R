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
#' ### Button & badge
#'
#' buttonInput(
#'   .style %>%
#'     background("primary"),
#'   id = "counter",
#'   label = "Count",
#'   badge(3) %>% background("light")
#' )
#'
badge <- function(...) {
  with_deps({
    tag <- tags$span(class = "badge")

    args <- style_dots_eval(..., .style = style_pronoun("yonder_badge"))

    tag <- tag_extend_with(tag, args)

    s3_class_add(tag, "yonder_badge")
  })
}

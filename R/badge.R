#' Badges
#'
#' Small highlighted content which scales to its parent's size.
#'
#' @param ... Named arguments passed as HTML attributes to the parent
#'   element or tag elements passed as children.
#'
#' @details
#'
#' Use [replaceElement()] and [removeElement()] to modify the contents of a
#' badge.
#'
#' @family rendering
#' @export
#' @examples
#'
#' ## Possible colors
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
#'       margin(2)
#'   })
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
badgeElement <- function(...) {
  component <- tags$span(
    class = "yonder-element badge",
    ...
  )

  attach_dependencies(component)
}

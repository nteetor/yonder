#' Badges
#'
#' Small highlighted content which scales to its parent's size.
#'
#' @param ... Additional named argument passed as HTML attributes to the parent
#'   element.
#'
#' @param pill One of `TRUE` or `FALSE` specifying if the badge has more rounded
#'   corners, defaults to `FALSE`.
#'
#' @family content
#' @export
#' @examples
#'
#' ## Buttons with badges
#'
#' buttonInput(
#'   id = "button1",
#'   label = "Process",
#'   badge(7) %>%
#'     background("cyan")
#' )
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
badge <- function(..., pill = FALSE) {
  element <- tags$span(
    class = collate(
      "badge",
      if (pill) "badge-pill"
    ),
    id = id,
    ...
  )

  attachDependencies(
    element,
    yonderDep()
  )
}

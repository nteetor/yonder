#' Include icons in applications
#'
#' Currently only FontAwesome icons are available.
#'
#' @usage
#'
#' icons$fa(name, ...)
#'
#' @param name A character string specifying the icon name, leading prefixes
#'   unique to the icon set are not required.
#'
#' @param ... Named arguments passed as HTML attributes to the parent element.
#'
#' @seealso
#'
#' For a complete list of possible FontAwesome icons please refer to
#' [http://fontawesome.io/icons/](http://fontawesome.io/icons/).
#'
#' @aliases fa
#' @format NULL
#' @export
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       icons$fa("thumbs-up"),
#'       icons$fa("bathtub"),
#'       icons$fa("cog"),
#'       icons$fa("clock-o"),
#'       icons$fa("microphone"),
#'       icons$fa("print")
#'       # and more!
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
icons <- structure(
  list(),
  name = "icons",
  class = c("module", "list")
)

icons$fa <- function(name, ...) {
  if (!is.character(name)) {
    stop(
      "invalid `icons$fa` argument, `name` must be a character string",
      call. = FALSE
    )
  }

  if (!grepl("^[a-z]", name) || grepl("fa-", name)) {
    stop(
      'invalid `icons$fa` argument, `name` should not include a leading "fa-" ',
      'or "-"',
      call. = FALSE
    )
  }

  tags$i(
    class = collate(
      "fa",
      paste0("fa-", name)
    ),
    `aria-hidden` = "true",
    ...,
    `font-awesome`()
  )
}

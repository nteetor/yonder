#' Default reactive domain
#'
#' A simple wrapper around [shiny::getDefaultReactiveDomain].
#'
#' @export
default_reactive_domain <- function() {
  shiny::getDefaultReactiveDomain()
}

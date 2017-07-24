#' Nav breadcrumbs
#'
#' Build a navbar.
#'
#' @param location Initial nav location, defaults to `NULL`.
#'
#' @examples
#'
breadcrumbs <- function(location = NULL) {
  tags$ol(
    class = "dull-breadcrumbs"
  )
}

addCrumb <- function(id, location, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      action = "add",
      crumb = location
    )
  )
}

removeCrumb <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      action = "remove"
    )
  )
}

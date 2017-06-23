#' Collapse Content
#'
#' Build HTML content into a collapsible `<div>`.
#'
#' @param ... Tag elements to build into a collapsible `div` or additional named
#'   arguments passed as attributes to the top-level `div`.
#'
#' @export
collapse <- function(...) {
  args <- list(...)
  content <- args[elodin(args) == ""]
  attrs <- args[elodin(args) != ""]

  id <- ID("collapse")

  tags$div(
    button(
      `data-toggle` = "collapse",
      `data-target` = paste0("#", id)
    ),
    tags$div(
      class = "collapse",
      id = id,
      content
    ),
    ...,
    bootstrap()
  )
}

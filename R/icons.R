#' Icons
#'
#' Currently only FontAwesome icons.
#'
#' @usage
#'
#' icons$na(name, ...)
#'
#' @param name A character string specifying the icon name, leading prefixes
#'   unique to the icon set are not required.
#'
#' @param ... Named arguments passed to the icon element as HTML attributes.
#'
#' @format NULL
#' @export
#' @examples
#'
#' icons$fa("thumbs-up")
#'
icons <- list()

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
    `aria-hidden` = TRUE,
    ...,
    `font-awesome`()
  )
}

#' Include icons in applications
#'
#' Currently only FontAwesome icons are available.
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
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       fontAwesome("thumbs-up"),
#'       fontAwesome("bathtub"),
#'       fontAwesome("cog"),
#'       fontAwesome("clock-o"),
#'       fontAwesome("microphone"),
#'       fontAwesome("print")
#'       # and more!
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
fontAwesome <- function(name, ...) {
  if (!is.character(name)) {
    stop(
      "invalid `fontAwesome` argument, `name` must be a character string",
      call. = FALSE
    )
  }

  if (!grepl("^[a-z]", name) || grepl("fa-", name)) {
    stop(
      'invalid `fontAwesome` argument, `name` should not include a leading ',
      '"fa-" or "-"',
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

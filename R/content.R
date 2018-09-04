#' Content
#'
#' Build page content.
#'
#' @noRd
#' @family content
#' @name index
#' @layout index
NULL

#' Headings
#'
#' Display headings are not meant to replace the standard HTML heading tags,
#' they are a stand out alternative for eye-catching titles.
#'
#' @param ... Character strings specifying the heading text or additional named
#'   arguments passed as HTML attributes to the parent element.
#'
#' @family content
#' @export
#' @examples
#'
#' ## Bigger, bolder
#'
#' d1("Eye-catching!")
#'
#' d2("Just incredible")
#'
#' d3("Wowie, zowie")
#'
#' d4("You'll never guess what happens next.")
#'
d1 <- function(...) d(1, ...)

#' @rdname d1
#' @export
d2 <- function(...) d(2, ...)

#' @rdname d1
#' @export
d3 <- function(...) d(3, ...)

#' @rdname d1
#' @export
d4 <- function(...) d(4, ...)

d <- function(level, ...) {
  if (!(level %in% 1:4)) {
    stop(
      "invalid `d` argument, `level` must be one of 1, 2, 3, or 4",
      call. = FALSE
    )
  }

  tags$h1(
    class = paste0("display-", level),
    ...,
    include("core")
  )
}

#' Jumbotron
#'
#' Highlight messages.
#'
#' @param title A character string specifying the jumbotron's title.
#'
#' @param subtitle A character string specifying the jumbotron's subtitle.
#'
#' @param ... Additional tag elements or named arguments passed as HTML
#'   attributes to the parent element.
#'
#' @param fluid One of `TRUE` or `FALSE` specifying if the jumbotron fills the
#'   width of its parent container, defaults to `TRUE`.
#'
#' @family content
#' @export
#' @examples
#'
#' ## Landing pages
#'
#' jumbotron(
#'   title = "Welcome, welcome!",
#'   subtitle = "This simple jumbotron-style component calls attention to a new feature",
#'   tags$p(
#'     "Here we can talk more about this excellently superb new feature.",
#'     "The best."
#'   )
#' )
#'
jumbotron <- function(title, subtitle, ..., fluid = TRUE) {
  tags$div(
    class = collate(
      "jumbotron",
      if (fluid) "jumbotron-fluid"
    ),
    d3(title),
    tags$p(
      class = "lead",
      subtitle
    ),
    if (length(elements(list(...))) > 0) tags$hr(class = "my-4"),
    ...,
    include("core")
  )
}

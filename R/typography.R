#' Text and Heading Styles
#'
#' @description
#'
#' These function encapsulate Bootstrap classes for styling text and headings.
#' Display headings are not meant to replace the standard HTML heading tags,
#' they are a stand out alternative for eye-catching titles. Use `lead` to
#' emphasize a paragraph or snippet of text.
#'
#' `mark` and `small` are HTML class-based alternatives to `<mark>` and
#' `<small>`. Typically, `<mark>` is used to indicate relevance. By using
#' Bootstrap's class alternatives one can utilize the highlighting aspect
#' of `<mark>` while avoiding the usage and purpose restrictions.
#'
#' @param ... Child elements or named arguments passed as HTML attributes
#'   to the parent element.
#'
#' @name typography
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       d1("Eye-catching!"),
#'       d3("Wowza."),
#'       d5("You'll never guess what happens next."),
#'       h1("This is an <h1> heading for comparision")
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
d1 <- function(...) d(1, ...)

#' @rdname typography
#' @export
d2 <- function(...) d(2, ...)

#' @rdname typography
#' @export
d3 <- function(...) d(3, ...)

#' @rdname typography
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
#' @param ... Additional elements or named arguments passed as HTML attributes
#'   to the parent element.
#'
#' @param fluid One of `TRUE` or `FALSE` specifying if the jumbotron fills the
#'   width of its parent container, defaults to `TRUE`, in which case the
#'   jumbotron fills the width of its parent container.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       jumbotron(
#'         title = "Hello, world!",
#'         subtitle = "This simple jumbotron-style component calls attention to a new feature",
#'         tags$p(
#'           "Here we can talk more about this excellently superb new feature.",
#'           "The best."
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
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

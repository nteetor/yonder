#' Headings
#'
#' Display headings are not meant to replace the standard HTML heading tags,
#' they are a stand out alternative for eye-catching titles.
#'
#' @param ... Any number of character strings or tag elements or named arguments
#'   passed as HTML attributes to the parent element.
#'
#' @family content
#' @export
#' @examples
#'
#' ### d1
#'
#' d1("Eye-catching!")
#'
#' ### d2
#'
#' d2("Just incredible")
#'
#' ### d3
#'
#' d3("Wowie, zowie")
#'
#' ### d4
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
  element <- tags$h1(
    class = paste0("display-", level),
    ...
  )

  attachDependencies(
    element,
    yonderDep()
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
#'   width of its parent container, defaults to `FALSE`.
#'
#' @family content
#' @export
#' @examples
#'
#' ### Landing page welcome
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
jumbotron <- function(title, subtitle, ..., fluid = FALSE) {
  element <- tags$div(
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
    ...
  )

  attachDependencies(
    element,
    yonderDep()
  )
}

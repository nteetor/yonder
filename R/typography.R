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
#' @param ... Child elements, additional HTML classes, or HTML attributes
#'   passed to the parent element.
#'
#' @name typography
NULL

#' @rdname typography
#' @export
#' @examples
#' display1("Eye-catching!")
#'
display1 <- function(...) display(1, ...)

#' @rdname typography
#' @export
display2 <- function(...) display(2, ...)

#' @rdname typography
#' @export
display3 <- function(...) display(3, ...)

#' @rdname typography
#' @export
display4 <- function(...) display(4, ...)

#' @rdname typography
#' @export
display5 <- function(...) display(5, ...)

display <- function(level, ...) {
  if (!(level %in% 1:5)) {
    stop(
      "invalid `display` argument, `level` must be one of 1, 2, 3, 4, or 5",
      call. = FALSE
    )
  }

  tags$h1(
    class = paste0("display-", level),
    ...,
    bootstrap()
  )
}

#' @rdname typography
#' @export
#' @examples
#' lead(
#'   "Some text you want to make sure catches",
#'   "the reader's eye."
#' )
#'
lead <- function(...) {
  tags$p(
    class = "lead",
    ...,
    bootstrap()
  )
}

#' @rdname typography
#' @export
mark <- function(...) {
  tags$span(class = "mark", ...)
}

#' @rdname typography
#' @export
small <- function(...) {
  tags$span(class = "small", ...)
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
jumbotron <- function(title, subtitle, ...) {
  tags$div(
    class = "jumbotron",
    display3(title),
    lead(subtitle),
    if (length(elements(list(...))) > 0) tags$hr(class = "my-4"),
    ...,
    bootstrap()
  )
}

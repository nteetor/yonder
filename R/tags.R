#' Responsive images and figures
#'
#' A small update to `tags$img` and `tags$figure`. Create responsive images with
#' `img`. `figure` has specific arguments for an image child element and image
#' caption.
#'
#' @param src A character string specifying the source of the image.
#'
#' @param image An `<img>` tag, typically a call to `img`.
#'
#' @param caption A character string specifying the image caption, defaults to
#'   `NULL`.
#'
#' @param ... Additional tag elements or named arguments passed as HTML attributes
#'   to the parent element.
#'
#' @family content
#' @export
img <- function(src, ...) {
  attachDependencies(
    tags$img(
      class = "img-fluid",
      src = src,
      ...
    ),
    bootstrapDep()
  )
}

#' @rdname img
#' @export
figure <- function(image, caption = NULL, ...) {
  if (!is_tag(image)) {
    stop(
      "invalid `figure` argument, `image` must be a tag element",
      call. = FALSE
    )
  }

  attachDependencies(
    tags$figure(
      class = "figure",
      tagAddClass(image, "figure-img"),
      if (!is.null(caption)) {
        tags$figcaption(
          class = "figure-caption",
          caption
        )
      },
      ...
    ),
    bootstrapDep()
  )
}

#' Cleaner blockquotes
#'
#' Stylized blockquotes, an updated builder function for `<blockquote>`.
#'
#' @param ... Any number of tags elements or character strings passed as child
#'   elements or named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param source The quote source, use `tags$cite` to format the source title,
#'   defaults to `NULL`.
#'
#' @param align One of `"left"` or `"right"`, defaults to `"left"`.
#'
#' @family content
#' @export
#' @examples
#'
#' ### Simple example
#'
#' blockquote(
#'   "Anyone can love a thing because.",
#'   "That's as easy as putting a penny in your pocket.",
#'   "But to love something despite.",
#'   "To know the flaws and love them too.",
#'   "That is rare and pure and perfect.",
#'   source = tags$span(
#'     "Patrick Rothfuss,", tags$cite("The Wise Man's Fear")
#'   )
#' )
#'
blockquote <- function(..., source = NULL, align = "left") {
  attachDependencies(
    tags$blockquote(
      class = collate(
        "blockquote",
        if (align == "right") "blockquote-reverse"
      ),
      ...,
      if (!is.null(source)) {
        tags$footer(class = "blockquote-footer", source)
      }
    ),
    bootstrapDep()
  )
}

#' Scrollable code snippets
#'
#' The `pre` function adds a maximum height and scroll bar to the standard
#' `<pre>` element.
#'
#' @param ... Text, tag elements, or named arguments passed as HTML attributes
#'   to the tag.
#'
#' @family content
#' @export
#' @examples
#'
#' ### Simple example
#'
#' pre(
#'   "shinyApp(",
#'   "  ui = container(",
#'   "    row(",
#'   "      column(",
#'   "      ",
#'   "      )",
#'   "    )",
#'   "  )",
#'   "  server = function(input, output) {",
#'   "  ",
#'   "  }",
#'   ")"
#' )
#'
pre <- function(...) {
  attachDependencies(
    tags$pre(
      class = "pre-scrollable",
      ...
    ),
    bootstrapDep()
  )
}

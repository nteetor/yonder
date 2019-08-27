#' Headings
#'
#' Display headings are not meant to replace the standard HTML heading tags,
#' they are a stand out alternative for eye-catching titles.
#'
#' @param ... Any number of character strings or tag elements or named arguments
#'   passed as HTML attributes to the parent element.
#'
#' @family components
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
  dep_attach({
    tags$h1(class = paste0("display-", level), ...)
  })
}

#' Jumbotron
#'
#' A showcase banner, good for front or splash pages.
#'
#' @param ... Tag elements passed as child elements or named arguments passed as
#'   HTML attributes to the parent element.
#'
#' @param title A character string specifying a title for the jumbotron,
#'   defaults to `NULL`, in which case a title is not added.
#'
#' @param subtitle A character string specifying a subtitle for the jumbotron,
#'   defaults to `NULL`, in which case a subtitle is not added.
#'
#' @family components
#' @export
#' @examples
#'
#' ### Landing page welcome
#'
#' jumbotron(
#'   title = "Welcome, welcome!",
#'   subtitle = "Here we are showcasing the very showcase itself.",
#'   tags$p(
#'     "Now let's talk more about that superb new feature."
#'   )
#' )
#'
jumbotron <- function(..., title = NULL, subtitle = NULL) {
  dep_attach({
    divider <- NULL

    if (!(is.null(title) && is.null(subtitle)) &&
        length(unnamed_values(list(...))) > 0) {
      divider <- tags$hr(class = "my-4")
    }

    tags$div(
      class = "jumbotron",
      if (!is.null(title)) d3(title),
      if (!is.null(subtitle)) tags$p(class = "lead", subtitle),
      divider,
      ...
    )
  })
}

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
#' @family components
#' @export
img <- function(src, ...) {
  assert_found(src)

  dep_attach({
    tags$img(
      class = "img-fluid",
      src = src,
      ...
    )
  })
}

#' @rdname img
#' @export
figure <- function(image, caption = NULL, ...) {
  assert_found(image)

  if (!is_tag(image)) {
    stop(
      "invalid argument in `figure()`, `image` must be a tag element",
      call. = FALSE
    )
  }

  dep_attach({
    tags$figure(
      class = "figure",
      tag_class_add(image, "figure-img"),
      if (!is.null(caption)) {
        tags$figcaption(
          class = "figure-caption",
          caption
        )
      },
      ...
    )
  })
}

#' Blockquotes
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
#' @family components
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
#'   source = list(
#'     "Patrick Rothfuss,", tags$cite("The Wise Man's Fear")
#'   )
#' )
#'
blockquote <- function(..., source = NULL, align = "left") {
  dep_attach({
    tags$blockquote(
      class = str_collate(
        "blockquote",
        if (align == "right") "blockquote-reverse"
      ),
      ...,
      if (!is.null(source)) {
        tags$footer(class = "blockquote-footer", source)
      }
    )
  })
}

#' Scrollable code snippets
#'
#' The `pre` function adds a maximum height and scroll bar to the standard
#' `<pre>` element.
#'
#' @param ... Text, tag elements, or named arguments passed as HTML attributes
#'   to the tag.
#'
#' @family components
#' @export
#' @examples
#'
#' ### Simple example
#'
#' pre(
#'   "shinyApp(",
#'   "  ui = container(",
#'   "    columns(",
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
  dep_attach({
    tags$pre(class = "pre-scrollable", ...)
  })
}

#' Group and label multiple inputs
#'
#' Use `fieldset` to associate and label inputs. This is good for screen readers
#' and other assistive technologies.
#'
#' @param legend A character string specifying the fieldset's legend.
#'
#' @param ... Any number of inputs to group or named arguments passed as HTML
#'   attributes to the parent element.
#'
#' @family layout functions
#' @export
#' @examples
#'
#' ### Grouping related inputs
#'
#' fieldset(
#'   legend = "Pizza order",
#'   formGroup(
#'     "What toppings would you like?",
#'     div(
#'       checkbarInput(
#'         id = "toppings",
#'         choices = c(
#'           "Cheese",
#'           "Black olives",
#'           "Mushrooms"
#'         )
#'       )
#'     )
#'   ),
#'   formGroup(
#'     "Is this for delivery?",
#'     checkboxInput(
#'       id = "deliver",
#'       choice = "Deliver"
#'     )
#'   ),
#'   buttonInput("order", "Place order") %>%
#'     background("blue")
#' )
#'
fieldset <- function(..., legend = NULL) {
  if (!is.null(legend) && !is.character(legend)) {
    stop(
      "invalid argument in `fieldset()`, `legend` must be a character string",
      call. = FALSE
    )
  }

  dep_attach({
    args <- list(...)

    component <- tags$fieldset(
      class = "form-group",
      if (!is.null(legend)) {
        tags$legend(
          class = "col-form-legend",
          legend
        )
      },
      tags$div(
        unnamed_values(args)
      )
    )

    tag_attributes_add(component, named_values(args))
  })
}

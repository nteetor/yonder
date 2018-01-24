#' Responsive Images and Figures
#'
#' A small update to `<img>` and `<figure>`. Additional arguments has been added
#' to the `img` builder function. Figures have specific arguments for an `img`
#' child element and caption.
#'
#' @param fluid If `TRUE`, the image will scale with its parent element,
#'   defaults to `TRUE`.
#'
#' @param align For `img`, one of `"left"` or `"right"` specifying which side of
#'   the parent element the image should align to, defaults to `NULL` in which
#'   case no alignment is applied.
#'
#'   For `figure`, one of `"left"`, `"right"`, or `"center"` specifying which
#'   side of the figure the figure caption is aligned to, defaults to `"left"`.
#'
#' @param thumbnail If `TRUE`, the image is rendered with a small border,
#'   defaults to `FALSE`.
#'
#' @param image An `img` element, it is best to leave the image as fluid,
#'   defaults to `NULL`.
#'
#' @param caption A character vector specifying a caption for the image,
#'   defaults to `NULL`.
#'
#' @family content
#' @aliases figure image
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       # A figure with a,
#'       #   - fluid image
#'       #   - left-aligned caption
#'       figure(
#'         image = img(src = "http://bit.ly/2qchbEB"),
#'         caption = "Stock cat photo."
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
img <- function(..., fluid = TRUE, align = NULL, thumbnail = FALSE) {
  tags$img(
    class = collate(
      if (fluid) "img-fluid",
      if (thumbnail) "img-thumbnail",
      if (!is.null(align)) paste0("float-", align)
    ),
    ...,
    includes()
  )
}

#' @rdname img
#' @export
figure <- function(..., image = NULL, caption = NULL, align = "left") {
  tags$figure(
    ...,
    class = collate(
      if (!is.null(image)) tagEnsureClass(image, "figure-img"),
      if (!is.null(caption)) {
        tags$figcaption(
          class = collate(
            "figure-caption",
            if (align %in% c("center", "right")) paste0("text-", align)
          ),
          caption
        )
      }
    ),
    includes()
  )
}

#' Cleaner Blockquotes
#'
#' Stylized blockquotes, an updated builder function for `<blockquote>`.
#'
#' @param source The quote source, use `tags$cite` to format the source title,
#'   defaults to `NULL`.
#'
#' @param align One of `"left"` or `"right"`, defaults to `"left"`.
#'
#' @family content
#' @export
#' @examples
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
  tags$blockquote(
    class = collate(
      "blockquote",
      if (align == "right") "blockquote-reverse"
    ),
    ...,
    if (!is.null(source)) {
      tags$footer(class = "blockquote-footer", source)
    },
    includes()
  )
}

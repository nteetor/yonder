#' Add Tooltips and Popovers
#'
#' Both functions are a means of adding help text to HTML components. Tooltips
#' appear on hover and popovers appear when the element is clicked.
#'
#' @param content The tag to add a tooltip or popover to.
#'
#' @param text The tooltip or popover text.
#'
#' @param placement A character vector specifying where the tooltip or popover
#'   is placed, defaults to top, one of `"left"`, `"top"`, `"right"`, or
#'   `"bottom"`.
#'
#' @export
#' @examples
#'
tooltip <- function(content, text, placement = "top") {
  if (!is_tag(content)) {
    stop(
      "invalid `tooltip` argument, `content` must be a tag object",
      call. = FALSE
    )
  }

  if (!re(placement, "top|left|bottom|right", FALSE)) {
    stop(
      "invalid `tooltip` argument, `placement` must be one of ",
      '"top", "left", "bottom", or "right"',
      call. = FALSE
    )
  }

  content$attribs$`data-toggle` <- "tooltip"
  content$attribs$`data-placement` <- placement
  content$attribs$title <- as.character(text)
  content$children <- append(content$children, list(bootstrap()))

  content
}

#' @rdname tooltip
#' @export
#' @examples
#' popover(
#'   buttonInput("Click me!"),
#'   "This text appears when the button is clicked"
#' )
#'
popover <- function(content, text, placement = "top") {
  if (!is_tag(content)) {
    stop(
      "invalid `popover` argument, `content` must be a tag object",
      call. = FALSE
    )
  }

  if (!re(placement, "top|left|bottom|right", FALSE)) {
    stop(
      "invalid `popover` argument, `placement` must be one of ",
      '"top", "left", "bottom", or "right"',
      call. = FALSE
    )
  }

  content$attribs$`data-container` <- "body"
  content$attribs$`data-toggle` <- "popover"
  content$attribs$`data-placement` <- placement
  content$attribs$`data-content` <- as.character(text)
  content$children <- c(content$children, bootstrap())

  content
}

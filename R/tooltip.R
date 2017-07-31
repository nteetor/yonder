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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       listGroupInput(
#'         tooltip(
#'           listGroupItem("Item 1"),
#'           "This is the first item",
#'           placement = "bottom"
#'         ),
#'         tooltip(
#'           listGroupItem("Item 2"),
#'           "This is the second item"
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
tooltip <- function(content, text, placement = "top") {
  if (!(placement %in% c("top", "left", "bottom", "right"))) {
    stop(
      'tooltip `placement` must be one of "top", "left", "bottom", or "right"',
      call. = FALSE
    )
  }

  if (!is_tag(content)) {
    stop("content must be a `tag`", call. = FALSE)
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
#'   "This text appears on click"
#' )
#'
#' # list items with popovers
#' listGroup(
#'   popover(
#'     listGroupItem("Some text"),
#'     "The first list item"
#'   ),
#'   popover(
#'     listGroupItem("More text"),
#'     "The second list item"
#'   ),
#'   popover(
#'     listGroupItem("Final text"),
#'     "Did you find this text?"
#'   )
#' )
#'
popover <- function(content, text, placement = "top") {
  if (!(placement %in% c("top", "left", "bottom", "right"))) {
    stop(
      'popover `placement` must be one of "top", "left", "bottom", or "right"',
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

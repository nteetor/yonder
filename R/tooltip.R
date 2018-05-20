#' Tooltips
#'
#' Both functions are a means of adding help text to HTML components. Tooltips
#' appear on hover. To add tooltips to text first wrap the text in a `span()` tag
#' element.
#'
#' @param .tag A tag element.
#'
#' @param text The tooltip text.
#'
#' @param placement One of `"top"`, `"right"`, `"bottom"`, or `"left"`
#'   specifying what side of the tag element the tooltip appears on.
#'
#' @export
#' @examples
#'
#' div(
#'   "The island of ",
#'   span("Yll") %>%
#'     tooltip("An island of south of the Commonwealth")
#' )
#'
tooltip <- function(.tag, text, placement = "top") {
  if (!is_tag(.tag)) {
    stop(
      "invalid `tooltip` argument, `.tag` must be a tag object",
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

  .tag$attribs$`data-toggle` <- "tooltip"
  .tag$attribs$`data-placement` <- placement
  .tag$attribs$title <- as.character(text)
  .tag$children <- append(.tag$children, list(include("core")))

  .tag
}

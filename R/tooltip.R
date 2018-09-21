#' Tooltips
#'
#' Add a tooltip to a tag element. Tooltips may be placed above, below, left, or
#' right of an element.
#'
#' @param .tag A tag element.
#'
#' @param text The tooltip text.
#'
#' @param placement One of `"top"`, `"right"`, `"bottom"`, or `"left"`
#'   specifying what side of the tag element the tooltip appears on.
#'
#' @family content
#' @export
#' @examples
#'
#' div(
#'   "The island of ",
#'   span("Yll") %>%
#'     tooltip("An island of south of the Commonwealth")
#' )
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       checkboxInput("add", "Add more") %>%
#'         display("inline-block") %>%
#'         tooltip("How to know")
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
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
  .tag <- attachDependencies(
    .tag,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  .tag
}

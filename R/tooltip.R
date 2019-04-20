#' Tooltips
#'
#' Add a tooltip to a tag element. Tooltips may be placed above, below, left, or
#' right of an element.
#'
#' @param tag A tag element.
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
#' ### Tooltips galore
#'
#' formGroup(
#'   label = tags$label(
#'     "An exciting input",
#'     tooltip(span(icon("info-circle")), "What is exciting here?")
#'   ),
#'   radioInput(
#'     id = "radios",
#'     choices = c("Ready", "Set", "Go")
#'   )
#' )
#'
#' ### Describing links (link inputs)
#'
#' div(
#'   p("Nunc rutrum turpis sed pede."),
#'   p(
#'     "Donec posuere augue in ",
#'     linkInput(NULL, "quam.") %>%
#'       tooltip("This is bound to do something")
#'   ),
#'   p(
#'     "Etiam vel tortor sodales ",
#'     linkInput(NULL, "tellus") %>%
#'       tooltip("Tell us more?"),
#'     " ultricies commodo."
#'   )
#' )
#'
tooltip <- function(tag, text, placement = "top") {
  assert_tag()
  assert_possible(placement, c("top", "right", "bottom", "left"))

  tag$attribs$`data-toggle` <- "tooltip"
  tag$attribs$`data-placement` <- placement
  tag$attribs$title <- as.character(text)

  attach_dependencies(tag)
}

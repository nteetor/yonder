#' Button or link tooltips
#'
#' Use `tooltip()` to contruct a tooltip for a button or link input.
#'
#' @param ... Character strings or tag elements (such as `em` or `b`) specifying
#'   the contents of the tooltip.
#'
#' @param placement One of `"top"`, `"right"`, `"bottom"`, or `"left"`
#'   specifying what side of the tag element the tooltip appears on.
#'
#' @param fade One of `TRUE` or `FALSE` specifying if the tooltip fades in when
#'   shown and fades out when hidden, defaults to `TRUE`.
#'
#' @family content
#' @export
#' @examples
#'
#' ### Link with tooltip
#'
#' linkInput(
#'   id = "link1",
#'   "A link",
#'   tooltip = tooltip("But, with a tooltip!")
#' )
#'
tooltip <- function(..., placement = "top", fade = TRUE) {
  assert_possible(placement, c("top", "right", "bottom", "left"))
  assert_possible(fade, c(TRUE, FALSE))

  list(
    fade = if (fade) "true" else "false",
    placement = placement,
    title = coerce_content(unnamed_values(list(...)))
  )
}

tag_tooltip_add <- function(tag, tooltip) {
  if (!is.null(tooltip)) {
    tag <- tag_attributes_add(
      tag,
      `data-animation` = tooltip$fade,
      `data-html` = "true",
      `data-placement` = tooltip$placement,
      title = tooltip$title,
      `data-toggle` = "tooltip"
    )
  }

  tag
}

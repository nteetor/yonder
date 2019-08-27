#' @param placement One of `"top"`, `"right"`, `"bottom"`, or `"left"`
#'   specifying what side of the tag element the tooltip appears on.
#'
#' @param fade One of `TRUE` or `FALSE` specifying if the tooltip fades in when
#'   shown and fades out when hidden, defaults to `TRUE`.
#'
#' @rdname buttonInput
#' @export
tooltip <- function(..., placement = "top", fade = TRUE) {
  assert_possible(placement, c("top", "right", "bottom", "left"))
  assert_possible(fade, c(TRUE, FALSE))

  dep_attach({
    list(
      fade = if (fade) "true" else "false",
      placement = placement,
      title = coerce_content(unnamed_values(list(...)))
    )
  })
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

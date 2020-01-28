#' Badges
#'
#' Small highlighted content which scales to its parent's size. A badge may
#' be dynamically updated with [replaceContent()], in which case be sure to
#' pass an `id` argument as part of `...`.
#'
#' @param ... Named arguments passed as HTML attributes to the parent
#'   element or tag elements passed as children to the parent element.
#'
#' @includeRmd man/roxygen/badge.Rmd
#'
#' @family components
#' @export
badge <- function(...) {
  with_deps({
    tag <- tags$span(class = "badge")

    args <- style_dots_eval(..., .style = style_pronoun("yonder_badge"))

    tag <- tag_extend_with(tag, args)

    s3_class_add(tag, "yonder_badge")
  })
}

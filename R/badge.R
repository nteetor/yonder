#' Badges
#'
#' Highlight small pieces of content with badges. A badge's size scales with
#' their parent's size.
#'
#' @param ... Any number of child elements passed to the parent element. Named
#'   values are passed as HTML attributes to the parent element.
#'
#' @param appearance A string. The appearance of the badge.
#'
#' @return A [htmltools::tag] object.
#'
#' @family components
#'
#' @export
#'
#' @examplesIf rlang::is_interactive()
#'
#' badge(99)
#'
#' badge(
#'   class = "text-bg-primary",
#'   "New"
#' )
#'
badge <- function(
  ...,
  appearance = c("default", "pill")
) {
  appearance <- arg_match(appearance)

  component <-
    tags$span(
      class = c(
        "badge",
        if (appearance == "pill") "rounded-pill"
      ),
      ...
    )

  component <-
    dependency_append(component)

  component <-
    s3_class_add(component, "bsides_badge")

  component
}

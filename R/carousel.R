#' Carousel
#'
#' A carousel of tag elements.
#'
#' @param ... Any number of tag elements.
#'
#' @param controls One of `TRUE` or `FALSE` specifying if next and previous
#'   slide controls are added to the carousel, defaults to `TRUE`.
#'
#' @param fade One of `TRUE` or `FALSE` specifying if slides fade in instead of
#'   sliding in, defaults to `FALSE`.
#'
#' @export
carousel <- function(..., controls = TRUE, fade = FALSE) {
  args <- list(...)

  items <- lapply(unnamed_values(args), function(x) {
    tags$div(
      class = "carousel-item",
      x
    )
  })

  if (length(items) > 0) {
    items[[1]] <- tag_class_add(items[[1]], "active")
  }

  component <- tags$div(
    class = str_collate(
      "carousel",
      "slide",
      if (fade) "carousel-fade"
    ),
    `data-ride` = "carousel",
    tags$div(
      class = "carousel-inner",
      items
    ),
    if (controls) {
      list(
        tags$a(
          class = "carousel-control-prev",
          role = "button",
          `data-slide` = "prev"
        ),
        tags$a(
          class = "carousel-control-prev",
          role = "button",
          `data-slide` = "next"
        )

      )
    }
  )

  tag_attributes_add(component, named_values(args))
}

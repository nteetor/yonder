#' Carousel
#'
#' A carousel of tag elements.
#'
#' @param ... Any number of tag elements.
#'
#' @param id A character string specifying an optional id for the carousel,
#'   defaults to `NULL`.
#'
#' @param controls One of `TRUE` or `FALSE` specifying if next and previous
#'   slide controls are added to the carousel, defaults to `TRUE`.
#'
#' @param fade One of `TRUE` or `FALSE` specifying if slides fade in instead of
#'   sliding in, defaults to `FALSE`.
#'
#' @export
carousel <- function(..., id = NULL, controls = TRUE, fade = FALSE) {
  args <- list(...)

  id <- id %||% generate_id("carousel")

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
    id = id,
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
          href = paste0("#", id),
          `data-slide` = "prev",
          tags$span(
            class = "carousel-control-prev-icon",
            `aria-hidden` = "true"
          ),
          tags$span(
            class = "sr-only",
            "Previous"
          )
        ),
        tags$a(
          class = "carousel-control-next",
          role = "button",
          href = paste0("#", id),
          `data-slide` = "next",
          tags$span(
            class = "carousel-control-next-icon",
            `aria-hidden` = "true"
          ),
          tags$span(
            class = "sr-only",
            "Next"
          )
        )

      )
    }
  )

  tag_attributes_add(component, named_values(args))
}

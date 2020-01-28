#' Alert boxes
#'
#' Use an alert element to let the user know of successes or to call attention
#' to problems.
#'
#' @param ... Character strings specifying the text of the alert or additional
#'   named arguments passed as HTML attributes to the alert element.
#'
#' @param dismissible One of `TRUE` or `FALSE` specifying if the alert may be
#'   dismissed by the user, defaults to `TRUE`.
#'
#' @param fade One of `TRUE` or `FALSE` specifying if the alert fades out or
#'   immediately disappears when dismissed, defaults to `TRUE`.
#'
#' @includeRmd man/roxygen/alert.Rmd
#'
#' @family components
#' @export
alert <- function(..., dismissible = TRUE, fade = TRUE) {
  with_deps({
    tag <- tags$div(
      class = str_collate(
        "alert",
        if (dismissible) "alert-dismissible",
        if (dismissible && fade) "fade show"
      ),
      role = "alert"
    )

    alert_mask <- list(
      a = function(...) tags$a(class = "alert-link", ...),
      linkInput = function(...) linkInput(class = "alert-link", ...),
      h1 = function(...) tags$h1(class = "alert-heading", ...),
      h2 = function(...) tags$h2(class = "alert-heading", ...),
      h3 = function(...) tags$h3(class = "alert-heading", ...),
      h4 = function(...) tags$h4(class = "alert-heading", ...),
      h5 = function(...) tags$h5(class = "alert-heading", ...),
      h6 = function(...) tags$h6(class = "alert-heading", ...)
    )

    args <- style_dots_eval(
      ...,
      .style = style_pronoun("yonder_alert"),
      .mask = alert_mask
    )

    tag <- tag_extend_with(tag, args)

    if (dismissible) {
      tag <- tag_children_add(tag, list(
        tags$button(
          type = "button",
          class = "close",
          `data-dismiss` = "alert",
          `aria-label` = "Close",
          tags$span(
            `aria-hidden` = "true",
            HTML("&times;")
          )
        )
      ))
    }

    s3_class_add(tag, "yonder_alert")
  })
}

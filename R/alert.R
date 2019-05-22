#' Alert boxes
#'
#' Use an alert element to let the user know of successes or to call attention
#' to problems.
#'
#' @param ... Character strings specifying the text of the alert or additional
#'   named arguments passed as HTML attributes to the alert element.
#'
#' @param dismissible One of `TRUE` or `FALSE` specifying if the alert may be
#'   dismissed by the user, deafults to `TRUE`.
#'
#' @param fade One of `TRUE` or `FALSE` specifying if the alert fades out or
#'   immediately disappears when dismissed, defaults to `TRUE`.
#'
#' @family components
#' @export
#' @examples
#'
#' ### Default alert
#'
#' alert("Donec at pede.") %>%
#'   background("blue")
#'
#' ### A more complex alert
#'
#' alert(
#'   h4("Etiam vel tortor sodales"),
#'   hr(),
#'   p("Fusce commodo.")
#' ) %>%
#'   background("amber")
#'
alert <- function(..., dismissible = TRUE, fade = TRUE) {
  args <- eval(substitute(alist(...)))

  body <- lapply(
    unnamed_values(args),
    eval,
    envir = list2env(
      list(
        a = function(...) tags$a(class = "alert-link", ...),
        h1 = function(...) tags$h1(class = "alert-heading", ...),
        h2 = function(...) tags$h2(class = "alert-heading", ...),
        h3 = function(...) tags$h3(class = "alert-heading", ...),
        h4 = function(...) tags$h4(class = "alert-heading", ...),
        h5 = function(...) tags$h5(class = "alert-heading", ...),
        h6 = function(...) tags$h6(class = "alert-heading", ...)
      )
    )
  )

  component <- tags$div(
    class = str_collate(
      "alert alert-grey",
      if (dismissible) "alert-dismissible",
      if (dismissible && fade) "fade show"
    ),
    role = "alert",
    body,
    if (dismissible) {
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
    }
  )

  compoment <- tag_attributes_add(component, named_values(list(...)))

  attach_dependencies(component)
}

#' Radio, radio bars and groups
#'
#' Create radio controls. Radio bars are stylized as button bars, but act as
#' radio groups.
#'
#' @param content A character vector specifying the label of the radio control,
#'   defaults to `NULL`.
#'
#' @param context Used to specify the visual context of the radioBar, one of
#'   `"primary"`, `"secondary"`, `"success"`, `"info"`, `"warning"`, `"danger"`,
#'   or `"link"`, defaults to `"secondary"`.
#'
#' @param name A character vector specifying the HTML name attribute of the
#'   input tag, defaults to `NULL`.
#'
#' @param disable If `TRUE`, the radio control is initialized with in a disabled
#'   state, defaults to `FALSE`.
#'
#' @param ... Optional, additional named arguments passed as HTML attributes.
#'
#' @export
radio <- function(content = NULL, value = NULL, name = NULL, inline = FALSE,
                  disable = FALSE, ...) {
  tags$div(
    class = collate(
      "form-check",
      if (inline) "form-check-line"
    ),
    if (disable) disabled = NA,
    ...,
    tags$label(
      class = "form-check-label",
      tags$input(
        class = "form-check-input",
        type = "radio",
        name = name,
        value = value,
        if (disable) disabled = NA,
        content
      )
    ),
    bootstrap()
  )
}

#' @rdname radio
#' @export
radioBar <- function(content = NULL, context = "secondary", name = NULL, ...) {
  tags$div(
    class = "btn-group",
    `data-toggle` = "buttons",
    ...,
    lapply(
      content,
      function(x) {
        tags$label(
          class = collate(
            "btn",
            paste0("btn-", context)
          ),
          name = name,
          autocomplete = "off",
          x
        )
      }
    ),
    bootstrap()
  )
}

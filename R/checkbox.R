#' Checkbox, checkbox bars and groups
#'
#' Checkbox inputs, be sure to include an `id` argument to register the checkbox
#' as a reactive input. Checkbox bars are checkboxes group and styled as a
#' button bar, but still act as a checkbox group.
#'
#' @param label,labels A character vector or list of tag elements used as the
#'   checkbox labels, defaults to `NULL`.
#'
#' @param value A character vector specifying the value of the checkbox,
#'   defaults to `NULL`.
#'
#' @param inline If `TRUE`, the button is rendered inline, defaults to `FALSE`.
#'
#' @param check If `TRUE`, the button is in the checked state when initially
#'   rendered, defaults to `FALSE`.
#'
#' @param context Used to specify the visual context of the checkboxBar, one of
#'   `"primary"`, `"secondary"`, `"success"`, `"info"`, `"warning"`, `"danger"`,
#'   or `"link"`, defaults to `"secondary"`.
#'
#' @param ... Additional named arguments passed on as HTML attributes to the
#'   parent element.
#'
#' @export
#' @examples
#'
#' stub
#'
checkbox <- function(label = NULL, value = NULL, inline = FALSE, check = FALSE,
                     disable = FALSE, ...) {
  tags$div(
    class = collate(
      "dull-checkbox",
      "form-check",
      if (inline) "form-check-inline",
      if (disable) disabled = NA
    ),
    tags$label(
      class = "form-check-label",
      tags$input(
        class = collate(
          "form-check-input",
          if (disable) disabled = NA
        ),
        type = "checkbox",
        value = value,
        label
      )
    ),
    ...
  )
}

#' @rdname checkbox
#' @export
updateCheckbox <- function(id, context, session = getDefaultReactiveDomain()) {
  if (!(context %in% c("success", "warning", "danger"))) {
    stop(
      'invalid `updateCheckbox` argument, `context` must be one "success", ',
      '"warning", or "danger"',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      context = paste0("has-", context)
    )
  )
}

#' @rdname checkbox
#' @export
checkboxBar <- function(labels = NULL, context = "secondary", ..., id = NULL) {
  if (bad_context(context, extra = c("primary", "secondary", "link"))) {
    stop(
      'invalid checkboxBar `context`, expecting one of "primary", "secondary", ',
      '"success", "info", "warning", "danger", or "link"',
      call. = FALSE
    )
  }

  tags$div(
    class = "btn-group",
    `data-toggle` = "buttons",
    lapply(
      labels,
      function(x) {
        tags$label(
          class = collate(
            "btn",
            paste0("btn-", context)
          ),
          tags$input(
            type = "checkbox",
            autocomplete = "off",
            x
          )
        )
      }
    ),
    ...,
    id = id,
    bootstrap()
  )
}

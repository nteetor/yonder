#' Checkbox inputs and checkbox bars
#'
#' A reactive input for selecting one or more values. A checkbox bar is a
#' visually re-styling of a group of checkboxes. A checkbox bar appears as a set
#' of buttons, but still acts as a checkbox group. Because checkbox bars are
#' pseudo-buttons a visual context may be specified.
#'
#' @param id A character string specifying the id of the checkbox bar, if
#'   specified a reactive input is available to the shiny server function,
#'   defaults to `NULL`.
#'
#' @param labels A character vector specifying the labels of the checkboxes,
#'   defaults to `NULL`.
#'
#' @param values A character vector specifying the values of the checkboxes,
#'   must be the same length as `labels`, defaults to `NULL`.
#'
#' @param checked A logical vector specifying which of the checkboxes render in
#'   a checked state, if specified must be the same length as `labels`, defaults
#'   to `NULL`. If unspecified all checkboxes render in an unchecked state.
#'
#' @param inline If `TRUE`, the checkbox options are rendered inline, otherwise
#'   the checkbox options appear on individual lines, defaults to `FALSE`.
#'
#' @param bar If `TRUE`, changes only the visual appearance of a group of
#'   checkboxes, checkboxes are rendered as a button bar or set of buttons,
#'   defaults to `FALSE`.
#'
#' @param context Applied only when `bar = TRUE`, one of `"primary"`,
#'   `"secondary"`, `"success"`, `"info"`, `"warning"`, or `"danger"` specifying
#'   the visual context of the checkbox bar, defaults to `"secondary"`.
#'
#' @param ... Additional named arguments passed on as HTML attributes to the
#'   parent element.
#'
#' @export
#' @examples
#'
#' stub
#'
checkboxInput <- function(labels = NULL, values = NULL, checked = NULL,
                          inline = FALSE, bar = FALSE, context = "secondary",
                          ..., id = NULL) {
  if (length(labels) != length(values)) {
    stop(
      "invalid `checkboxInput` arguments, `labels` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(checked) && length(checked) != length(labels)) {
    stop(
      "invalid `checkboxInput` arguments, `checked` and `labels` must be the ",
      "same length",
      call. = FALSE
    )
  }


  #
  # checkbox bar
  #
  if (bar) {
    if (!re(context, "primary|secondary|success|info|warning|danger", len0 = FALSE)) {
      stop(
        "invalid `checkboxBarInput` argument, `context` must be one of ",
        '"primary", "secondary", "success", "info", "warning", or "danger"',
        call. = FALSE
      )
    }

    return(
      tags$div(
        class = collate(
          "dull-checkbox",
          "form-check",
          "btn-group"
        ),
        `data-toggle` = "buttons",
        if (length(labels) > 0) {
          Map(
            function(label, value, check) {
              tags$label(
                class = collate(
                  "btn",
                  paste0("btn-", context)
                ),
                tags$input(
                  type = "checkbox",
                  autocomplete = "off",
                  `data-value` = value,
                  checked = if (check) NA,
                  label
                )
              )
            },
            labels,
            values,
            checked %||% FALSE
          )
        },
        ...,
        id = id,
        bootstrap()
      )
    )
  }

  tags$div(
    class = collate(
      "dull-checkbox",
      "form-check",
      if (!inline) "custom-controls-stacked"
    ),
    if (length(labels) > 0) {
      Map(
        function(label, value, check) {
          tags$label(
            class = collate(
              "custom-control",
              "custom-checkbox"
            ),
            tags$input(
              class = "custom-control-input",
              type = "checkbox",
              `data-value` = value,
              checked = if (check) NA,
              tags$span(
                class = "custom-control-indicator"
              ),
              tags$span(
                class = "custom-control-description",
                label
              )
            )
          )
        },
        labels,
        values,
        checked %||% FALSE
      )
    },
    ...,
    id = id,
    bootstrap()
  )
}

#' @rdname checkboxInput
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

#' Radios
#'
#' Create an input of one or more radio inputs. If an `id` parameter is
#' specified the `name` attribute of each child radio element is given this
#' value.
#'
#' @param id A character string specifying the id of the radio input,
#'
#' @param labels A list or character vectors of labels for each of the
#'   individual radio elements, defaults to `NULL`.
#'
#' @param values A list or vector of values for each of the individual radio
#'   elements, defaults to `NULL`.
#'
#' @param selected A logical vector specifying which of the radio choices
#'   renders in the selected state, defaults to `NULL`. If unspecified the first
#'   value is selected by default.
#'
#' @param inline If `TRUE`, the radio options render inline, otherwise the
#'   options appear on individual lines, defaults to `FALSE`.
#'
#' @param ... Additional named arguments passed on to the parent element as
#'   HTML attributes.
#'
#' @family inputs
#' @export
#' @examples
#'
#' stub
#'
radioInput <- function(labels = NULL, values = NULL, selected = NULL,
                       inline = FALSE, ..., id = NULL) {
  if (length(labels) != length(values)) {
    stop(
      "invalid `radioInput` arguments, `labels` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  if (!is.null(selected)) {
    if (!is.logical(selected)) {
      stop(
        "invalid `radioInput` argument, `selected` must be a logical vector",
        call. = FALSE
      )
    }

    if (sum(selected) != 1) {
      stop(
        "invalid `radioInput` argument, `selected` must contain only one TRUE ",
        "value",
        call. = FALSE
      )
    }

    if (length(selected) != length(labels)) {
      stop(
        "invalid `radioInput` argument, `selected` and `labels` must be the ",
        "same length",
        call. = FALSE
      )
    }
  }

  selected <- selected %||% c(TRUE, vector("logical", length(labels) - 1))

  tags$div(
    class = collate(
      "dull-radios",
      "dull-input",
      "form-group",
      if (!inline) "custom-controls-stacked"
    ),
    if (!is.null(labels)) {
      Map(
        function(label, value, check) {
          tags$label(
            class = collate(
              "custom-control",
              "custom-radio"
            ),
            tags$input(
              class = "custom-control-input",
              type = "radio",
              name = id,
              value = value,
              checked = if (check) NA
            ),
            tags$span(
              class = "custom-control-indicator"
            ),
            tags$span(
              class = "custom-control-description",
              label
            )
          )
        },
        labels,
        values,
        selected
      )
    },
    ...,
    id = id,
    bootstrap()
  )
}

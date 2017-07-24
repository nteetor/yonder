#' Radios
#'
#' Create an input of one or more radio inputs. If an `id` parameter is
#' specified the `name` attribute of each child radio element is given this
#' value.
#'
#' @param labels A list or character vectors of labels for each of the
#'   individual radio elements, defaults to `NULL`.
#'
#' @param values A list or vector of values for each of the individual radio
#'   elements, one value may be named `checked` to indicate a default value for
#'   the element, defaults to `NULL`.
#'
#' @param stacked If `TRUE` the radio elements appear on sepearate lines,
#'   defaults to `FALSE`, in which case the radio elements are rendered inline.
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
radiosInput <- function(labels = NULL, values = NULL, stacked = FALSE, ...) {
  if (length(labels) != length(values)) {
    stop(
      "`radiosInput` arguments `labels` and `values` must be the same length",
      call. = FALSE
    )
  }

  args <- list(...)
  attrs <- attribs(args)

  tagConcatAttributes(
    tags$div(
      class = collate(
        "dull-radios dull-input form-group",
        if (stacked) "custom-controls-stacked"
      ),
      lapply(
        seq_along(labels),
        function(i) {
          tags$label(
            class = "custom-control custom-radio",
            tags$input(
              class = "custom-control-input",
              type = "radio",
              name = attrs$id,
              value = values[[i]],
              checked = if (names2(values[i]) == "checked") NA
            ),
            tags$span(class = "custom-control-indicator"),
            tags$span(
              class = "custom-control-description",
              labels[[i]]
            )
          )
        }
      ),
      ...,
      id = id,
      bootstrap()
    ),
    attrs
  )
}

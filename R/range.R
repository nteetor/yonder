#' A range or slider input
#'
#' Create a range input. A range input allows a user fine control over a
#' bounded value, think volume control.
#'
#' @param id A character string specifying the id of the range input.
#'
#' @param min The minimum value of the range.
#'
#' @param max The maxmium value of the range.
#'
#' @param step Controls possible values, the values of the range input are
#'   multiples of `step`. Defaults to `1`. If `length` is specified the `step`
#'   argument is ignored.
#'
#' @param length An alternative to `step`, a number specifying how many values
#'   the range input has. Defaults to `NULL`, in which case `step` is used.
#'
#' @param default The default value of the range input. Defaults to `NULL` in
#'   which case the default value is midway between the minium and maximum
#'   values.
#'
#' @param labels A character vector of two labels or a list of two tag elements
#'   to use as labels for the minimum and maximum of the range. Defaults to
#'   `NULL` in which case `min` and `max` are used as the labels.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`, or `"danger"` specifying the visual context of the range
#'   input. Defaults to `NULL` in which case a visual context is not applied.
#'
#'   **Note**: On Chrome the entire range input is colored according to the
#'   context. On Firefox and Internet Explorer the lower half of the range input
#'   is colored according to the context. In the future, Chrome may support
#'   better styling.
#'
#' @param size One of `"small"` or `"large"` specifying a size transformation of
#'   the range input. Defaults to `NULL` in which case the size of the range
#'   input is not modified.
#'
#' @param track The corresponding CSS is not working.
#'
#' @param thumb One of `"square"` or `"rounded"` specifying the appearance of
#'   the thumb. Defaults to `NULL` in which case the thumb is circular.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           rangeInput(
#'             id = "rangelg",
#'             size = "large"
#'           ),
#'           rangeInput(
#'             id = "rangemd",
#'             default = 60
#'           ),
#'           rangeInput(
#'             id = "rangesm",
#'             size = "small"
#'           )
#'         ),
#'         col()
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           rangeInput(
#'             id = "range1",
#'             context = "primary",
#'             labels = c("Minimum", "Maximum")
#'           ),
#'           rangeInput(
#'             id = "range2",
#'             context = "warning"
#'           ),
#'           rangeInput(
#'             id = "range3",
#'             length = 4,
#'             context = "info"
#'           )
#'         ),
#'         col()
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
rangeInput <- function(id, min = 0, max = 100, step = 1, length = NULL,
                       default = NULL, labels = NULL, context = NULL,
                       size = NULL, track = NULL, thumb = NULL) {
  if (!is.null(length)) {
    step <- diff(seq(min, max, length.out = length))[1]
  }

  tags$div(
    class = "dull-input dull-range-input form-group",
    tags$div(
      class = "labels",
      tags$label(
        `for` = id,
        if (!is.null(labels)) labels[[1]] else min
      ),
      tags$label(
        `for` = id,
        if (!is.null(labels)) labels[[2]] else max
      )
    ),
    tags$input(
      type = "range",
      id = id,
      min = min,
      max = max,
      step = step,
      value = default,
      class = collate(
        "range",
        if (!is.null(context)) paste0("range-", context),
        if (!is.null(size)) {
          paste0("range-", switch(size, small = "sm", large = "lg"))
        },
        if (!is.null(track)) paste0("track-", track),
        # if (vertical) "range-vertical",
        if (!is.null(thumb)) paste0("thumb-", thumb)
      )
    )
  )
}

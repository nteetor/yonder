#' A range input
#'
#' A take on shiny's `sliderInput`.
#'
#' @param id A character string specifying the id of the range input or `NULL`.
#'
#' @param min A number specifying the minimum value of the range input, defaults
#'   to `0`.
#'
#' @param max A number specifying the maximum value of the range input, defaults
#'   to `100`.
#'
#' @param default A numeric vector between `min` and `max` specifying the
#'   default value of the range input.
#'
#'   For **rangeInput**, a single number, defaults to `min`.
#'
#'   For **intervalInput**, a vector of two numbers specifying the minimum and
#'   maximum of the slider interval, defaults to `c(min, max)`.
#'
#' @param step A number specifying the interval step of the range input,
#'   defaults to `1`.
#'
#' @param ticks One of `TRUE` or `FALSE` specifying if tick marks are added to
#'   the range input, defaults to `FALSE`. If `TRUE` tick marks are added,
#'   otherwise if `FALSE` tick marks are not added.
#'
#' @param labels A number specifying how many ticks are labeled, defaults to
#'   `4`. If `snap` is `TRUE`, this argument is ignored and tick labels are
#'   based on `step`.
#'
#' @param snap One of `TRUE` or `FALSE` specifying how the range input tick
#'   marks are labeled, defaults to `FALSE`. If `TRUE` the range input tick
#'   marks are adjusted to align with a multiple of `step`. If `FALSE` the range
#'   input tick marks are calculeted using `labels`.
#'
#' @param prefix A character string specifying a prefix for the range input
#'   slider value. Defaults to `NULL`, in which case a prefix is not prepended.
#'
#' @param suffix A character string specifying a suffix for the range input
#'   slider value. Defaults to `NULL`, in which case a prefix is not appended.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`, or `"danger"` specifying the visual context of the slider,
#'   defaults to `"secondary"`.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       rangeInput("default"),
#'       rangeInput("blue", context = "primary"),
#'       rangeInput("red", context = "danger"),
#'       rangeInput("white", context = "info", step = 10, snap = TRUE),
#'       rangeInput("yellow", context = "warning", prefix = "$", suffix = ".00")
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         print(input$default)
#'       })
#'
#'     }
#'   )
#' }
rangeInput <- function(id, min = 0, max = 100, default = min, step = 1,
                       ticks = TRUE, labels = 4, snap = FALSE, prefix = NULL,
                       suffix = NULL, context = "secondary") {
  tags$div(
    class = collate(
      "dull-range-input dull-input form-group",
      "range",
      if (!is.null(context)) paste0("range-", context)
    ),
    id = id,
    tags$input(
      class = "range",
      type = "text",
      `data-type` = "single",
      `data-min` = min,
      `data-max` = max,
      `data-step` = step,
      `data-from` = default,
      `data-separtor` = ",",
      `data-prefix` = prefix,
      `data-postfix` = suffix,
      `data-grid` = ticks,
      `data-grid-num` = labels,
      `data-grid-snap` = if (isTRUE(snap)) snap
    ),
    `ion-range-slider`()
  )
}

#' @param draggable One of `TRUE` or `FALSE` specifying if the user can drag the
#'   interval between an interval input's two sliders defaults to `FALSE`. If
#'   `TRUE` the user can drag the entire range, otherwise the interval is not
#'   draggable.
#'
#' @rdname rangeInput
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       intervalInput("gray"),
#'       intervalInput("green", default = c(25, 75), draggable = TRUE)
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         print(input$green)
#'       })
#'     }
#'   )
#' }
intervalInput <- function(id, min = 0, max = 100, default = c(min, max),
                          step = 1, draggable = FALSE,
                          ticks = TRUE, labels = 4, snap = FALSE,
                          prefix = NULL, suffix = NULL,
                          context = "secondary") {
  tags$div(
    class = collate(
      "dull-range-input dull-input form-group",
      "range",
      if (!is.null(context)) paste0("range-", context)
    ),
    id = id,
    tags$input(
      class = "range",
      type = "text",
      `data-type` = "double",
      `data-min` = min,
      `data-max` = max,
      `data-from` = default[1],
      `data-to` = default[2],
      `data-drag-interval` = draggable,
      `data-separtor` = ",",
      `data-prefix` = prefix,
      `data-postfix` = suffix,
      `data-grid` = ticks,
      `data-grid-num` = labels,
      `data-grid-snap` = if (isTRUE(snap)) snap
    ),
    `ion-range-slider`()
  )
}

# A range or slider input
#
# Create a range input. A range input allows a user fine control over a
# bounded value, think volume control.
#
# @param id A character string specifying the id of the range input.
#
# @param min The minimum value of the range.
#
# @param max The maxmium value of the range.
#
# @param step Controls possible values, the value of the range input is always
#   a multiple of `step`. Defaults to 1. If `length` is specified the `step`
#   argument is ignored.
#
# @param length An alternative to `step`, a number specifying how many values
#   the range input has. Defaults to `NULL`, in which case `step` is used.
#
# @param default The default value of the range input. Defaults to `NULL` in
#   which case the default value is midway between the minium and maximum
#   values.
#
# @param labels A character vector of two labels or a list of two tag elements
#   to use as labels for the minimum and maximum of the range. Defaults to
#   `NULL` in which case `min` and `max` are used as the labels.
#
# @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#   `"warning"`, or `"danger"` specifying the visual context of the range
#   input. Defaults to `NULL` in which case a visual context is not applied.
#
#   **Note**: On Chrome the entire range input is colored according to the
#   context. On Firefox and Internet Explorer the lower half of the range input
#   is colored according to the context. In the future, Chrome may support
#   better styling.
#
# @param size One of `"small"` or `"large"` specifying a size transformation of
#   the range input. Defaults to `NULL` in which case the size of the range
#   input is not modified.
#
# @param track The corresponding CSS is not working.
#
# @param thumb One of `"square"` or `"rounded"` specifying the appearance of
#   the thumb. Defaults to `NULL` in which case the thumb is circular.
#
# @export
# @examples
# if (interactive()) {
#   shinyApp(
#     ui = container(
#       row(
#         col(
#           rangeInput(
#             id = "rangelg",
#             size = "large"
#           ),
#           rangeInput(
#             id = "rangemd",
#             default = 60
#           ),
#           rangeInput(
#             id = "rangesm",
#             size = "small"
#           )
#         ),
#         col(
#           tags$h6("Large range"),
#           verbatimTextOutput("valuelg"),
#           tags$h6("Medium range"),
#           verbatimTextOutput("valuemd"),
#           tags$h6("Small range"),
#           verbatimTextOutput("valuesm")
#         )
#       )
#     ),
#     server = function(input, output) {
#       output$valuelg <- renderPrint({
#         input$rangelg
#       })
#
#       output$valuemd <- renderPrint({
#         input$rangemd
#       })
#
#       output$valuesm <- renderPrint({
#         input$rangesm
#       })
#     }
#   )
# }
#
# if (interactive()) {
#   shinyApp(
#     ui = container(
#       row(
#         col(
#           rangeInput(
#             id = "range1",
#             context = "primary",
#             labels = c("Minimum", "Maximum"),
#             step = 0.01
#           ),
#           rangeInput(
#             id = "range2",
#             context = "warning",
#             default = 0
#           ),
#           rangeInput(
#             id = "range3",
#             length = 5,
#             context = "info"
#           )
#         ),
#         col(
#           tags$h6("Primary range"),
#           verbatimTextOutput("primary"),
#           tags$h6("Warning range"),
#           verbatimTextOutput("warning"),
#           tags$h6("Info range"),
#           verbatimTextOutput("info")
#         )
#       )
#     ),
#     server = function(input, output) {
#       output$primary <- renderPrint({
#         input$range1
#       })
#
#       output$warning <- renderPrint({
#         input$range2
#       })
#
#       output$info <- renderPrint({
#         input$range3
#       })
#     }
#   )
# }
#
# rangeInput <- function(id, min = 0, max = 100, step = 1, length = NULL,
#                        default = NULL, labels = NULL, context = NULL,
#                        size = NULL, track = NULL, thumb = NULL) {
#   if (!is.null(length)) {
#     step <- diff(seq(min, max, length.out = length))[1]
#   }
#
#   default <- default %||% ceiling((min + max) / 2)
#   rid <- ID("range")
#
#   tags$div(
#     class = "dull-input dull-range-input form-group",
#     id = id,
#     tags$div(
#       class = "labels",
#       tags$label(
#         `for` = rid,
#         if (!is.null(labels)) labels[[1]] else min
#       ),
#       tags$label(
#         `for` = rid,
#         if (!is.null(labels)) labels[[2]] else max
#       )
#     ),
#     tags$input(
#       type = "range",
#       id = rid,
#       min = min,
#       max = max,
#       step = step,
#       value = default,
#       class = collate(
#         "range",
#         if (!is.null(context)) paste0("range-", context),
#         if (!is.null(size)) {
#           paste0("range-", switch(size, small = "sm", large = "lg"))
#         },
#         if (!is.null(track)) paste0("track-", track),
#         # if (vertical) "range-vertical",
#         if (!is.null(thumb)) paste0("thumb-", thumb)
#       )
#     )
#   )
# }

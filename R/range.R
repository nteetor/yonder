#' Ranges, intervals, and custom sliders
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
#' @param draggable One of `TRUE` or `FALSE` specifying if the user can drag the
#'   interval between an interval input's two sliders defaults to `FALSE`. If
#'   `TRUE` the slider interval may be dragged with the cursor, otherwise the
#'   interval is not draggable.
#'
#' @param choices A character vector specifying the labels along the slider
#'   input.
#'
#' @param values A character vector specifying the values of the slider input,
#'   defaults to `choices`.
#'
#' @param selected One of `values` specifying the initial value of the slider
#'   input, defaults to `NULL`, in which case the slider input defaults to the
#'   first choice.
#'
#' @param ticks One of `TRUE` or `FALSE` specifying if tick marks are added to
#'   the range input, defaults to `FALSE`. If `TRUE` tick marks are added,
#'   otherwise if `FALSE` tick marks are not added.
#'
#' @param fill One of `TRUE` or `FALSE` specifying whether the filled portion of
#'   a range or slider input is shown. If `FALSE` the filled porition is hidden.
#'
#'   For **rangeInput** the default is `TRUE`.
#'
#'   For **sliderInput** the default is `FALSE`.
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
#'   slider value, defaults to `NULL`, in which case a prefix is not prepended.
#'
#' @param suffix A character string specifying a suffix for the range input
#'   slider value, defaults to `NULL`, in which case a prefix is not appended.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Range inputs
#'
#' # Select from a range of numeric values.
#'
#' rangeInput(id = NULL) %>%
#'   background("yellow")
#'
#' ### Increase the number of labels
#'
#' rangeInput(
#'   id = NULL,
#'   default = 30,
#'   labels = 8
#' ) %>%
#'   background("purple")
#'
#' ### Increase thumb step
#'
#' # We'll hide the filled portion of the input with `fill` and change how
#' # tick marks are placed with `snap`.
#'
#' rangeInput(
#'   id = NULL,
#'   step = 10,  # <-
#'   snap = TRUE,
#'   fill = FALSE
#' ) %>%
#'   background("red")
#'
#' ### Interval inputs
#'
#' # Select an interval from a range of numeric values. Intervals are draggable
#' # by default, this can be toggled off with `draggable = FALSE`.
#'
#' intervalInput(
#'   id = NULL,
#'   default = c(45, 65)
#' ) %>%
#'     background("blue")
#'
#' ### sliderInput
#'
#' # Select a value from a set of choices using a slider.
#'
#' sliderInput
#'
#' sliderInput(
#'   id = NULL,
#'   choices = paste("Choice", 1:6)
#' )
#'
rangeInput <- function(id, min = 0, max = 100, default = min, step = 1,
                       ticks = TRUE, fill = TRUE, labels = 4, snap = FALSE,
                       prefix = NULL, suffix = NULL, ...) {
  input <- tags$div(
    class = "yonder-range bg-grey",
    id = id,
    tags$input(
      class = "range",
      type = "text",
      `data-type` = "single",
      `data-min` = min,
      `data-max` = max,
      `data-step` = step,
      `data-from` = default,
      `data-prettify-separator` = ",",
      `data-prefix` = prefix,
      `data-postfix` = suffix,
      `data-grid` = ticks,
      `data-grid-num` = labels,
      `data-grid-snap` = if (isTRUE(snap)) snap,
      `data-no-fill` = if (!fill) "true"
    ),
    ...
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep(), ionSliderDep())
  )

  input
}

#' @rdname rangeInput
#' @export
intervalInput <- function(id, min = 0, max = 100, default = c(min, max),
                          step = 1, draggable = FALSE,
                          ticks = TRUE, labels = 4, snap = FALSE,
                          prefix = NULL, suffix = NULL, ...) {
  input <- tags$div(
    class = "yonder-range bg-grey",
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
      `data-prettify-separator` = ",",
      `data-prefix` = prefix,
      `data-postfix` = suffix,
      `data-grid` = ticks,
      `data-grid-num` = labels,
      `data-grid-snap` = if (isTRUE(snap)) snap
    ),
    ...
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep(), ionSliderDep())
  )

  input
}

#' @rdname rangeInput
#' @export
sliderInput <- function(id, choices, values = choices, selected = NULL,
                        ticks = TRUE, fill = FALSE, prefix = NULL,
                        suffix = NULL, ...) {
  values <- vapply(values, as.character, character(1))

  # need to replace commas as ion rangeslider splits the string of values on the
  # string literal ","
  values <- encode_commas(values)
  choices <- encode_commas(choices)
  selected <- encode_commas(selected)

  input <- tags$div(
    class = "yonder-range bg-grey",
    id = id,
    tags$input(
      class = "range",
      type = "text",
      `data-type` = "single",
      `data-values` = paste0(values, collapse = ","),
      `data-choices` = paste0(choices, collapse = ","),
      `data-from` = if (!is.null(selected)) which(choices == selected)[1] - 1, # JS is 0-indexed
      `data-prefix` = prefix,
      `data-postfix` = suffix,
      `data-grid` = ticks,
      `data-hide-min-max` = TRUE,
      `data-no-fill` = if (!fill) "true"
    ),
    ...
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep(), ionSliderDep())
  )

  input
}

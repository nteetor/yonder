#' Inputs for numeric ranges
#'
#' Use `rangeInput()` and `intervalInput()` to allow users to select from a
#' range of numeric values. For a slider input with non-numeric values refer to
#' [sliderInput()].
#'
#' @inheritParams buttonInput
#'
#' @param min A number specifying the minimum value of the input, defaults to
#'   `0`.
#'
#' @param max A number specifying the maximum value of the input, defaults to
#'   `100`.
#'
#' @param default A numeric vector between `min` and `max` specifying the
#'   default value of the input.
#'
#'   For **rangeInput()**, a single number, defaults to `min`.
#'
#'   For **intervalInput()**, a vector of two numbers, defaults to
#'   `c(min, max)`.
#'
#' @param step A number specifying the interval step of the input, defaults to
#'   `1`.
#'
#' @param draggable One of `TRUE` or `FALSE` specifying if the user can drag the
#'   interval between an interval input's two sliders, defaults to `FALSE`. If
#'   `TRUE`, the slider interval may be dragged with the cursor.
#'
#' @param ticks One of `TRUE` or `FALSE` specifying if tick marks are added to
#'   the input, defaults to `TRUE`.
#'
#' @param fill One of `TRUE` or `FALSE` specifying whether the filled portion of
#'   a range or slider input is shown, defaults to `TRUE`.
#'
#' @param labels One of `TRUE`, `FALSE`, or a number specifying how labels are
#'   applied to tick marks.
#'
#'   If **numeric**, `labels` specifies the exact number of
#'   tick mark labels added to the input.
#'
#'   If **`TRUE`**, labels are added to the tick marks and the number of labels
#'   is determined by `step`.
#'
#'   If **`FALSE`**, labels are not added to the tick marks.
#'
#' @param prefix A character string specifying a prefix for the input value,
#'   defaults to `NULL`, in which case a prefix is not prepended.
#'
#' @param suffix A character string specifying a suffix for the input value,
#'   defaults to `NULL`, in which case a prefix is not appended.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Range inputs
#'
#' # Select from a range of numeric values.
#'
#' rangeInput(id = "range1") %>%
#'   background("yellow")
#'
#' ### Increase the number of labels
#'
#' rangeInput(
#'   id = "range2",
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
#'   id = "range3",
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
#'   id = "interval1",
#'   default = c(45, 65)
#' ) %>%
#'   background("blue")
#'
rangeInput <- function(id, min = 0, max = 100, default = min, step = 1,
                       ticks = TRUE, labels = 4, prefix = NULL,
                       suffix = NULL, fill = TRUE, ...) {
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
      `data-grid-snap` = if (isTRUE(labels)) labels,
      `data-no-fill` = if (!fill) "true"
    ),
    ...
  )

  attachDependencies(
    input,
    c(yonderDep(), ionSliderDep())
  )
}

#' @rdname rangeInput
#' @export
intervalInput <- function(id, min = 0, max = 100, default = c(min, max),
                          step = 1, ticks = TRUE, labels = 4, prefix = NULL,
                          suffix = NULL, draggable = FALSE, ...) {
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
      `data-grid-snap` = if (isTRUE(labels)) labels
    ),
    ...
  )

  attachDependencies(
    input,
    c(yonderDep(), ionSliderDep())
  )
}

#' Slider with custom choices
#'
#' A slider input with custom choices and values. Unlike [rangeInput()] or
#' [intervalInput()] the slider input does range over a set of numeric values.
#' Instead the slider input may be used similarly to a radio input.
#'
#' @inheritParams buttonInput
#'
#' @param choices A character vector specifying the slider labels.
#'
#' @param values A character vector specifying the values of the input,
#'   defaults to `choices`.
#'
#' @param selected One of `values` specifying the initial value of the slider
#'   input, defaults to `values[[1]]`.
#'
#' @param fill One of `TRUE` or `FALSE` specifying whether the filled portion of
#'   the slider input is shown, defaults to `FALSE`.
#'
#' @inheritParams rangeInput
#'
#' @family inputs
#' @export
#' @examples
#'
#' ### Custom chocies
#'
#' # Select a value from a set of choices using a slider.
#'
#' sliderInput(
#'   id = "slider1",
#'   choices = c("Closest", "Close", "Far", "Farthest")
#' )
#'
sliderInput <- function(id, choices, values = choices, selected = values[[1]],
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

  attachDependencies(
    input,
    c(yonderDep(), ionSliderDep())
  )
}

#' Date and time inputs
#'
#' A date time picker. Alternatively, use the date time range picker to select
#' a range of dates. The value of the date range picker is always two dates.
#'
#' @param id A character specifying the id of the datetime input.
#'
#' @param choices Date objects or character strings specifying the set of
#'   dates the user may choose from, defaults to `NULL` in which case the user
#'   may choose any date.
#'
#' @param selected Date objects or character strings specifying the dates
#'   selected by default in the date input, defaults `NULL` in which case no
#'   dates are selected by default.
#'
#' @param min,max Date objects or character strings in the format `YYYY-mm-dd`
#'   specifying the minimum and maximum date that can be selecetd, both
#'   default to `NULL` in which case there is no minimum or maximum value
#'   respectively.
#'
#' @param multiple One of `TRUE` or `FALSE` specifying whether multiple dates
#'   may be selected, if `TRUE` the user may select multiple dates and a vector
#'   of one or more dates is returned as the reactive value.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ## Preselect a date
#'
#' dateInput(
#'   id = NULL,
#'   selected = Sys.Date() + 1
#' )
#'
#' ## Set a min and max
#'
#' dateInput(
#'   id = NULL,
#'   min = Sys.Date() - 3,
#'   max = Sys.Date() + 3
#' )
#'
#' ## Select multiple dates
#'
#' dateInput(
#'   id = NULL,
#'   choices = Sys.Date() + seq(-6, 6, by = 2),
#'   selected = Sys.Date() + 1,
#'   multiple = TRUE
#' )
#'
#' ## Date ranges
#'
#' dateRangeInput(
#'   id = NULL,
#'   selected = c(Sys.Date(), Sys.Date() + 3)
#' )
#'
dateInput <- function(id, choices = NULL, selected = NULL, min = NULL,
                      max = NULL, multiple = FALSE, ...) {
  if (!is.null(choices)) {
    if (!(is_date(choices) || is.character(choices)) && !all(is_ymd(choices))) {
      stop(
        "invalid `dateInput()` argument, `choices` must be date object(s) or ",
        "character string in the format YYYY-mm-dd",
        call. = FALSE
      )
    }
  }

  if (!is.null(selected)) {
    if (!multiple && length(selected) > 1) {
      stop(
        "invalid `dateInput()` argument, if `multiple` is FALSE, `selected` ",
        "must be a single date object or character string",
        call. = FALSE
      )
    }

    if (!(is.character(selected) || is_date(selected)) && !all(is_ymd(selected))) {
      stop(
        "invalid `dateInput()` argument, `selected` must be a date object ",
        "or character string in the format YYYY-mm-dd",
        call. = FALSE
      )
    }
  }

  if (!is.null(min) && !is_ymd(min)) {
    stop(
      "invalid `dateInput()` argument, `min` must be a date object or ",
      "character string in the format YYYY-mm-dd",
      call. = FALSE
    )
  }

  if (!is.null(max) && !is_ymd(max)) {
    stop(
      "invalid `dateInput()` argument, `max` must be a date object or ",
      "character string in the format YYYY-mm-dd",
      call. = FALSE
    )
  }

  if (!is.null(selected) && multiple) {
    selected <- paste(
      vapply(selected, as.character, character(1)),
      collapse = "\\,"
    )
  }

  if (!is.null(choices)) {
    choices <- paste(vapply(choices, as.character, character(1)), collapse = "\\,")
  }

  shiny::registerInputHandler("yonder.date", dateHandler, TRUE)

  tags$input(
    class = "yonder-date form-control",
    id = id,
    type = "text",
    `data-default-date` = selected,
    `data-enable` = choices,
    # `data-alt-input` = "true",
    `data-min-date` = min,
    `data-max-date` = max,
    `data-date-format` = "Y-m-d",
    `data-mode` = if (multiple) "multiple",
    ...,
    include("flatpickr")
  )
}

#' @rdname dateInput
#' @export
dateRangeInput <- function(id, choices = NULL, selected = NULL, min = NULL,
                           max = NULL, ...)  {
  if (!is.null(choices)) {
    if (!(is.character(choices) || is_date(choices)) || !all(is_ymd(choices))) {
      stop(
        "invalid `dateRangeInput()` argument, `choices` must be date ",
        "object(s) and character string(s) in the format YYYY-mm-dd",
        call. = FALSE
      )
    }
  }

  if (!is.null(selected)) {
    if (length(selected) != 2) {
      stop(
        "invalid `dateRangeInput()` argument, `selected` must be NULL or a pair of ",
        "date objects or character strings",
        call. = FALSE
      )
    }

    if (!(is.character(selected) || is_date(selected)) || !is_ymd(selected)) {
      stop(
        "invalid `dateRangeInput()` argument, `selected` must be date ",
        "object(s) and character string(s) in the format YYYY-mm-dd",
        call. = FALSE
      )
    }
  }

  if (!is.null(min) && !is_ymd(min)) {
    stop(
      "invalid `dateRangeInput()` argument, `min` must be a date object or ",
      "character string in the format YYYY-mm-dd",
      call. = FALSE
    )
  }

  if (!is.null(max) && !is_ymd(max)) {
    stop(
      "invalid `dateRangeInput()` argument, `max` must be a date object or ",
      "character string in the format YYYY-mm-dd",
      call. = FALSE
    )
  }

  if (!is.null(selected)) {
    selected <- paste(vapply(selected, as.character, character(1)), collapse = "\\,")
  }

  if (!is.null(choices)) {
    choices <- paste(vapply(choices, as.character, character(1)), collapse = "\\,")
  }

  shiny::registerInputHandler("yonder.date", dateHandler, TRUE)

  tags$input(
    class = "yonder-date form-control",
    id = id,
    type = "text",
    `data-default-date` = selected,
    `data-enable` = choices,
    # `data-alt-input` = "true",
    `data-min-date` = min,
    `data-max-date` = max,
    `data-date-format` = "Y-m-d",
    `data-mode` = "range",
    ...,
    include("core"),
    include("flatpickr")
  )
}

dateHandler <- function(x, session, name) {
  if (length(x) == 0) {
    return(NULL)
  }

  sort(strptime(unlist(x), format = "%Y-%m-%d"))
}

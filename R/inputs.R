#' Update input choices and values
#'
#' Use `updateInput()` to replace an input's choices and values. Optionally,
#' a new choices may be selected.
#'
#' @param id A character string specifying the id of an input.
#'
#' @param choices A character vector or list of tag elements specifying new
#'   choices for the input.
#'
#' @param values An atomic vector specifying new values for the input.
#'
#' @param selected One of `values` specifying which choice to select, defaults
#'   to `NULL`, in which case a choice is not selected. Note that browsers may
#'   automatically select a choice if not specified.
#'
#' @section Button inputs:
#'
#' When updating a button input if `values` equals `choices`, the default value
#' for `values`, the value of the button input is left as is.
#'
#' Passing a non-numeric value will reset the button input's value.
#'
#' @section File inputs:
#'
#' Files inputs do not currently support `updateInput()`.
#'
#' @section Form inputs:
#'
#' Form inputs do not support `updateInput()`, instead update the specific
#' inputs within the form.
#'
#' @template session
#'
#' @family utilities
#' @export
updateInput <- function(id, choices, values = choices, selected = NULL,
                        session = getDefaultReactiveDomain()) {
  if (missing(choices)) {
    stop(
      "invalid `updateInput()` argument, `choices` must be specified",
      call. = FALSE
    )
  }

  if (is.null(session)) {
    stop(
      "invalid `updateInput()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  if (length(choices) == 0) {
    stop(
      "invalid `updateInput()` argument, `choices` must be contain at ",
      "least one value",
      call. = FALSE
    )
  }

  if (!is_strictly_list(choices) && !is.atomic(choices)) {
    stop(
      "invalid `updateInput()` argument, `choices` must be a list or vector",
      call. = FALSE
    )
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `updateInput()` arguments, `choices` and `values` must ",
      "contain the same number of values",
      call. = FALSE
    )
  }

  if (!is.null(selected) && !(selected %in% values)) {
    stop(
      "invalid `updateInput()` argument, `selected` must be one of `values`",
      call. = FALSE
    )
  }

  choices <- lapply(choices, function(x) HTML(as.character(x)))
  values <- lapply(values, as.character)
  selected <- lapply(selected, function(x) HTML(as.character(x)))

  session$sendInputMessage(id, list(
    type = "update",
    data = list(
      choices = choices,
      values = values,
      selected = selected
    )
  ))
}

#' Enable, disable input
#'
#' Prevent interacting with input choices.
#'
#' @param id A character string specifying the reactive id of an input.
#'
#' @param values A vector specifying values to enable or disable.
#'
#' @param invert One of `TRUE` or `FALSE`, if `TRUE` choices which do _not_ have
#'   a matching value are enabled or disabled, defaults to `FALSE`.
#'
#' @param reset One of `TRUE` or `FALSE`, if `TRUE` choices are all enabled
#'   prior to disabling choices, defaults to `FALSE`.
#'
#' @template session
#'
#' @export
enableInput <- function(id, values = NULL, invert = FALSE,
                        session = getDefaultReactiveDomain()) {
  values <- lapply(values, as.character)

  session$sendInputMessage(id, list(
    type = "enable",
    data = list(
      values = values,
      invert = invert
    )
  ))
}

#' @rdname enableInput
#' @export
disableInput <- function(id, values = NULL, invert = FALSE, reset = FALSE,
                         session = getDefaultReactiveDomain()) {
  values <- lapply(values, as.character)

  session$sendInputMessage(id, list(
    type = "disable",
    data = list(
      values = values,
      invert = invert,
      reset = reset
    )
  ))
}

#' Validate, invalidate input
#'
#' `invalidateInput()` and `validateInput()` are new utilities for conveying
#' information to users. `invalidateInput()` adds text to an input letting a
#' user know why an input is valid or invalid. Additionally, `invalidateInput()`
#' will immediately freeze an input. As a result, further observers or reactives
#' using the input are not triggered. `validateInput()` will immediately thaw
#' the reactive input, thus allowing subsequent observers and reactives to
#' trigger.
#'
#' @param id A character string specifying the reactive id of an input.
#'
#' @param message A character string specifying the message.
#'
#' @template session
#'
#' @export
invalidateInput <- function(id, message, session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "invalid `invalidateInput()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  session$sendInputMessage(id, list(
    type = "invalidate",
    data = list(
      message = message
    )
  ))
  session$freezeValue(session$input, id)

  invisible()
}

#' @rdname invalidateInput
#' @export
validateInput <- function(id, session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "invalid `validateInput()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  session$sendInputMessage(id, list(
    type = "validate",
    data = list()
  ))
  .subset2(session$input, "impl")$thaw(id)

  invisible()
}

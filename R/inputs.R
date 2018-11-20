#' Utilities
#'
#' Server-side functions.
#'
#' @noRd
#' @name index
#' @family utilities
#' @layout index
NULL

#' Update input
#'
#' Input utilities.
#'
#' @param id A character string.
#'
#' @param choices A character vector, tag element, or list specifying choices
#'   for the input.
#'
#' @param values An object specifying values for the input, this object is
#'   coerced to a character vector.
#'
#' @param selected One of `values` specifying which choice to select, defaults
#'   to `NULL`, in which case a choice is not selected. Note that browsers may
#'   automatically select a choice if not specified.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @export
updateInput <- function(id, choices, values = choices, selected = NULL,
                        session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "invalid call to `updateInput()`, must be called in a reactive context",
      call. = FALSE
    )
  }

  values <- as.character(values)

  if (is_tag(choices)) {
    choices <- list(choices)
  } else if (!is.null(choices) && !is_strictly_list(choices)) {
    choices <- as.list(choices)
  }

  if (length(choices) != length(values)) {
    stop(
      "invalid `updateInput()` arguments, `choices` and `values` must be the ",
      "same length",
      call. = FALSE
    )
  }

  values <- as.list(values)

  if (!is.null(selected)) {
    selected <- which(match2(selected, values, default = TRUE))
  }

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
#' @param id A character string.
#'
#' @param values A vector specifying values to enable or disable.
#'
#' @param invert One of `TRUE` or `FALSE`, if `TRUE` choices which do __not__
#'   have a matching value are enabled or disabled, defaults to `FALSE`.
#'
#' @param reset One of `TRUE` or `FALSE`, if `TRUE` choices are all enabled
#'   prior to disabling choices, defaults to `FALSE`.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @export
enableInput <- function(id, values, invert = FALSE,
                        session = getDefaultReactiveDomain()) {
  values <- as.list(as.character(values))

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
disableInput <- function(id, values, invert = FALSE, reset = FALSE,
                         session = getDefaultReactiveDomain()) {
  values <- as.list(as.character(values))

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
#' @param id A character string.
#'
#' @param message A character string specifying the message.
#'
#' @export
invalidateInput <- function(id, message, session = getDefaultReactiveDomain()) {
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
  session$sendInputMessage(id, list(
    type = "validate",
    data = list()
  ))
  .subset2(session$input, "impl")$thaw(id)

  invisible()
}


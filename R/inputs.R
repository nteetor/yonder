#' Utilities
#'
#' Server-side functions.
#'
#' @noRd
#' @name index
#' @family utilities
NULL

#' Update input
#'
#' Modify an input's choices, values, or selected choices. Importantly, an
#' input's choices and selected choices are updated after any values are
#' updated. Thus, `choices` and `selected` must refer to the new, updated
#' values.
#'
#' @param id A character string specifying the reactive id of an input.
#'
#' @param choices A character vector, tag element, or list specifying choices
#'   for the input.
#'
#'   If `choices` is an **unnamed** vector, list, or element then the input's
#'   choices are updated sequentially.
#'
#'   If `choices` is a **named** vector or list then the input's choices are
#'   matched by value. The names of `choices` refer to one or more possible
#'   values of the input and the values of `choices` are the new choice labels.
#'
#' @param values An atomic vector or list of atomic singleton values, values
#'   will be coerced to character strings.
#'
#'   If `values` is an **unnamed** vector or list then the input's values are
#'   updated sequentially.
#'
#' @param selected One of `values` specifying which choice to select, defaults
#'   to `NULL`, in which case a choice is not selected. Note that browsers may
#'   automatically select a choice if not specified.
#'
#' @template session
#'
#' @details
#'
#' If specifying new values with `values`, both `choices` and `selected` need to
#' refer to these new values.
#'
#' @export
updateInput <- function(id, choices = NULL, values = NULL, selected = NULL,
                        session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "invalid call to `updateInput()`, must be called in a reactive context",
      call. = FALSE
    )
  }

  # encapsulate tag element so we can compare lengths of `choices` and `values`
  if (is_tag(choices)) {
    choices <- list(choices)
  }

  if (!is.null(choices) && !is.null(values)) {
    if (is.null(names(choices)) && is.null(names(values))) {
      if (length(choices) != length(values)) {
        stop(
          "invalid `updateInput()` arguments, `choices` and `values` must be ",
          "the same length if unnamed",
          call. = FALSE
        )
      }
    }
  }

  if (!is.null(choices)) {
    choices <- Map(
      function(value, name) list(HTML(as.character(value)), name),
      choices,
      names(choices) %||% rep.int(list(NULL), length(choices)),
      USE.NAMES = FALSE
    )
  }

  if (!is.null(values)) {
    values <- Map(
      function(value, name) list(as.character(value), name),
      values,
      names(values) %||% rep.int(list(NULL), length(values)),
      USE.NAMES = FALSE
    )
  }

  if (!is.null(selected)) {
    selected <- lapply(selected, as.character)
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

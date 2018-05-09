sendUpdateMessage <- function(id, type, data) {
  if (all(names2(data) == "")) {
    data <- vapply(data, as.character, character(1), USE.NAMES = FALSE)
  }

  msg <- list(
    type = paste0("update:", type),
    data = data
  )

  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
    stop(
      "`sendUpdateMessage()` must be called from within a reactive context",
      call. = FALSE
    )
  }

  domain$sendInputMessage(id, msg)
}

#' Update choices, values, selected choices
#'
#' Functions to update choices, values, and selected choices.
#'
#' @param id A character string specifying the id of an input to update.
#'
#' @param ... Named values or unnamed values specifying which and how existing
#'   or new input choices, values, or which values are selected are updated,
#'   values are [dots_list()] allowing the use of bangs and splices.
#'
#' @export
updateChoices <- function(id, ...) {
  args <- dots_list(...)

  sendUpdateMessage(id, "choices", args)
}

#' @rdname updateChoices
#' @export
updateValues <- function(id, ...) {
  args <- dots_list(...)

  sendUpdateMessage(id, "values", args)
}

#' @rdname updateChoices
#' @export
updateSelected <- function(id, ...) {
  args <- dots_list(...)

  stop("`updateSelected` is not yet implemented")
}

#' Input validation
#'
#' `markInvalid` and `markValid` are new utilities for conveying information to
#' users. Both functions can add text to an input letting a user know why an
#' input is valid or invalid. Additionally, `markInvalid` will immediately
#' freeze an input. As a result, further observers or reactives using the input
#' are not triggered. `markValid` will immediately thaw the reactive input, thus
#' allowing subsequent observers and reactives to trigger.
#'
#' @param id A character string specifying the id of an input to mark as invalid
#'   or valid.
#'
#' @param msg A character string letting the user know why an input is invalid
#'   or valid. For `markInvalid` this argument is required, for `markValid` the
#'   argument is optional.
#'
#' @family utilities
#' @export
markInvalid <- function(id, msg) {
  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
    stop(
      "problem with `invalid`, input `", id, "` cannot be invalidated outside ",
      "of a reactive context",
      call. = FALSE
    )
  }

  domain$sendInputMessage(id, list(
    type = "mark:invalid",
    data = list(msg = msg)
  ))
  domain$freezeValue(domain$input, id)

  invisible()
}

#' @rdname markInvalid
#' @export
markValid <- function(id, msg = NULL) {
  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
    stop(
      "problem with `valid`, input `", id, "` cannot be invalidated outside ",
      "of a reactive context",
      call. = FALSE
    )
  }

  domain$sendInputMessage(id, list(
    type = "mark:valid",
    data = list(msg = msg)
  ))
  .subset2(domain$input, "impl")$thaw(id)

  invisible()
}

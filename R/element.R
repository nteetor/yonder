#' Rendering tag elements
#'
#' If your application needs to dynamically render elements consider using
#' `elementOutput()` and `replaceElement()`.
#'
#' @param id A character string specifying a reactive id.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @inheritParams updateInput
#'
#' @details
#'
#' These functions are experimental and are subject to change. Additionally, they
#' may be moved from this package entirely.
#'
#' @family rendering
#' @keywords internal
#' @export
elementOutput <- function(id, ...) {
  output <- tags$div(
    id = id,
    ...
  )

  attachDependencies(output, yonderDep())
}

#' @rdname elementOutput
#' @export
replaceElement <- function(id, element, session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `renderElement()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (is.null(session)) {
    stop(
      "invalid `renderElement()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:element", list(
    type = "render",
    data = list(
      target = id,
      content = HTML(as.character(element)),
      dependencies = processDeps(element, session)
    )
  ))
}

#' @rdname elementOutput
#' @export
removeElement <- function(id, session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `removeElement()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (is.null(session)) {
    stop(
      "invalid `removeElement()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:element", list(
    type = "remove",
    data = list(
      target = id
    )
  ))
}

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
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
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
  assert_id()

  attach_dependencies(
    tags$div(
      id = id,
      ...
    )
  )
}

#' @rdname elementOutput
#' @export
replaceElement <- function(id, element, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

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
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:element", list(
    type = "remove",
    data = list(
      target = id
    )
  ))
}

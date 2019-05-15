#' Dynamic elements
#'
#' An application may require dynamic content. This content may be quite simple.
#' The content could also be quite variable. These tools are an alternative to
#' the standard `output` related `render*()` functions.
#'
#' @param id A character string specifying a reactive id.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element or unnamed arguments passed as the new contents of the output
#'   element.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @details
#'
#' These functions are experimental and are subject to change. Additionally,
#' they may be moved from this package entirely.
#'
#' @family rendering
#' @export
outputElement <- function(id, ...) {
  assert_id()

  attach_dependencies(
    tags$div(
      id = id,
      class = "yonder-element",
      ...
    )
  )
}

#' @rdname outputElement
#' @export
replaceElement <- function(id, ..., session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  args <- list(...)
  content <- coerce_content(unnamed_values(args))

  session$sendCustomMessage("yonder:element", list(
    type = "render",
    data = list(
      target = id,
      content = content,
      dependencies = processDeps(unnamed_values(args), session)
    )
  ))
}

#' @rdname outputElement
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

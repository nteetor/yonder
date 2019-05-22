#' Dynamic content
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
#' @export
replaceContent <- function(id, ..., session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  args <- list(...)
  content <- coerce_content(unnamed_values(args))
  attrs <- named_values(args)

  session$sendCustomMessage("yonder:content", list(
    type = "replace",
    data = list(
      id = id,
      content = content,
      attrs = attrs,
      dependencies = processDeps(unnamed_values(args), session)
    )
  ))
}

#' @rdname replaceContent
#' @export
removeContent <- function(id, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:content", list(
    type = "remove",
    data = list(
      id = id
    )
  ))
}

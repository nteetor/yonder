#' Badge outputs
#'
#' Small highlighted content which scales to its parent's size. Useful for
#' displaying dynamically changing counts or tickers, drawing attention to new
#' options, or tagging content.
#'
#' @param id A character string specifying the id of the badge output.
#'
#' @param ... Additional named argument passed as HTML attributes to the parent
#'   element.
#'
#' @param expr An expression which returns a character string specifying the
#'   label of the badge.
#'
#' @param env The environment in which to evaluate `expr`, defaults to the
#'   calling environment.
#'
#' @param quoted One of `TRUE` or `FALSE` specifying if `expr` is a quoted
#'   expression.
#'
#' @family outputs
#' @export
#' @examples
#'
#' ## Buttons with badges
#'
#' # Typically, you would use `renderBadge()` to update a badge's
#' # value. Here we are hard-coding a default value of 7.
#'
#' buttonInput(
#'   id = NULL,
#'   label = "Process",
#'   badgeOutput(
#'     id = NULL,
#'     7
#'   ) %>%
#'     background("cyan")
#' )
#'
#' ## Possible colors
#'
#' colors <- c(
#'   "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'   "yellow", "amber", "orange", "grey", "white"
#' )
#'
#' div(
#'   lapply(
#'     colors,
#'     function(color) {
#'       badgeOutput(
#'         id = NULL,
#'         color
#'       ) %>%
#'         background(color) %>%
#'         margin(2)
#'     }
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
badgeOutput <- function(id, ...) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `badgeOutput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  output <- tags$span(
    class = "yonder-badge badge",
    id = id,
    ...
  )

  output <- attachDependencies(
    output,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  output
}

#' @rdname badgeOutput
#' @export
renderBadge <- function(expr, env = parent.frame(), quoted = FALSE) {
  installExprFunction(expr, "func", env, quoted)

  createRenderFunction(
    func,
    function(data, session, name) {
      list(data = data)
    },
    badgeOutput
  )
}

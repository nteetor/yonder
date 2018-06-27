rescale <- function(x) {
  (x - min(x)) / (max(x) - min(x)) * 100
}

#' Sparkline output
#'
#' Display concise, reactive inline bar, line, or dot charts.
#'
#' @param id A character string specifying the id of the sparkline output.
#'
#' @param type One of `"bar"`, `"dot"`, or `"dotline"` specifying the type of
#'   chart to render, defaults to `"bar"`.
#'
#' @param labels If `TRUE`, the first and last value of the sparkline data
#'  are used as labels, defaults to `TRUE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param expr An expression which returns a numeric vector specifying the
#'   values of the sparkline. These values will be scaled to 0 through 100.
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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       sparklineOutput("bars")
#'     ),
#'     server = function(input, output) {
#'       output$bars <- renderSparkline({
#'         c(30, 20, 44, 50, 90)
#'       })
#'     }
#'   )
#' }
#'
sparklineOutput <- function(id, type = "bar", labels = TRUE, ...) {
  if (!re(type, "bar|dot|dotline", FALSE)) {
    stop(
      "invalid `sparklineOutput()` argument, `type` must be one of ",
      '"bar", "dot", or "dotline"',
      call. = FALSE
    )
  }

  tags$span(
    class = collate(
      "dull-sparkline-output",
      paste0("sparks-", type)
    ),
    id = id,
    `data-labels` = if (labels) "true" else "false",
    ...,
    include("core")
  )
}

#' @family outputs
#' @rdname sparklineOutput
#' @export
renderSparkline <- function(expr, env = parent.frame(), quoted = FALSE) {
  installExprFunction(expr, "func", env, quoted)

  createRenderFunction(
    func,
    function(data, session, name) {
      if (!length(data)) {
        return(list())
      }

      values <- round(rescale(data))

      list(
        data = values,
        from = as.character(data[1]),
        to = as.character(data[length(data)])
      )
    },
    sparklineOutput
  )
}

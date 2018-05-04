#' Sparkline output
#'
#' Display concise, reactive inline bar, line, or dot charts.
#'
#' @param id A character string specifying the id of the sparkline output.
#'
#' @param type One of `"bar"`, `"dot"`, or `"line"` specifying the type of
#'   chart to render, defaults to `"bar"`.
#'
#' @param labels If `TRUE`, the first and last value of the sparkline data
#'  are used as labels, defaults to `TRUE`.
#'
#' @param values A numeric vector of values specifying the sparkline data
#'   points. Bar and dot sparklines expect values to be between 0 and 100 and
#'   line sparklines expect values to be between 0 and 10.
#'
#' @export
#' @examples
#'
sparklineOutput <- function(id, type = "bar", labels = TRUE, ...) {
  if (!re(type, "bar|dot|line", FALSE)) {
    stop(
      "invalid `sparklineOutput` argument, `type` must be one of ",
      '"bar", "dot", or "line"',
      call. = FALSE
    )
  }

  tags$span(
    class = collate(
      "dull-sparkline-output",
      paste0("spark-", type, "-medium")
    ),
    id = id,
    `data-labels` = if (labels) "true" else "false",
    ...
  )
}

#' @rdname sparklineOutput
#' @export
renderSparkline <- function(values, env = parent.frame(), quoted = FALSE) {
  valuesFun <- shiny::exprToFunction(values, env, quoted)

  function() {
    list(
      values = as.numeric(valuesFun())
    )
  }
}

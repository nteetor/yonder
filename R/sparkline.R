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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           listGroupInput(
#'             id = "toc",
#'             items = list(
#'               tags$div(
#'                 class = "d-flex w-100 justify-content-between",
#'                 "Bars",
#'                 sparklineOutput("bar", type = "bar")
#'               ),
#'               tags$div(
#'                 class = "d-flex w-100 justify-content-between",
#'                 "Dots",
#'                 sparklineOutput("dot", type = "dot")
#'               ),
#'               tags$div(
#'                 class = "d-flex w-100 justify-content-between",
#'                 "Line",
#'                 sparklineOutput("line", type = "line")
#'               )
#'             ),
#'             values = c("bar", "dot", "line")
#'           )
#'         ),
#'         col(
#'
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       gen10 <- function() {
#'         sample(10:100, 10, replace = TRUE) %/% 10 * 10
#'       }
#'
#'       output$bar <- renderSparkline({
#'         gen10()
#'       })
#'
#'       output$dot <- renderSparkline({
#'         gen10()
#'       })
#'
#'       output$line <- renderSparkline({
#'         gen10()
#'       })
#'     }
#'   )
#' }
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

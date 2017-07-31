#' Progress bars
#'
#' Create simple or composite progress bars. To create a composite progress bar
#' pass multiple calls to `bar` to `progress`. Each `bar` component may have its
#' own `id` argument, value, label, and context.
#'
#' @param ... `bar` elements passed to progress or named arguments passed as
#'   HTML attributes to the respective parent element.
#'
#' @param value An integer(s), between 0 and 100, specifying the initial
#'   value(s) of a progress bar or components of a progress bar, defaults to 0.
#'
#' @param label Label(s) for a progress bar or components of a progress bar,
#'   defaults to `NULL`.
#'
#' @param context Used to specify the visual context of the progress bar,
#'   `"success"`, `"info"`, `"warning"` or `"danger"`.
#'
#' @param striped If `TRUE`, the progress bar has a striped gradient, defaults
#'   to `FALSE`.
#'
#' @param animated If `TRUE`, the progress bar is animated and `striped` is set
#'   to `TRUE`, defaults to `FALSE`.
#'
#' @aliases progressbar
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       progress(
#'         bar(id = "clicks", value = 0)
#'       ),
#'       buttonInput(id = "inc", "Increment progress")
#'     ),
#'     server = function(input, output, session) {
#'       clickPercentage <- reactive({
#'          min(input$inc$count, 10) / 10 * 100
#'       })
#'
#'       output$clicks <- renderBar(
#'         value = clickPercentage(),
#'         label = {
#'           cp <- clickPercentage()
#'           if (cp > 0) {
#'             paste0(cp, "%")
#'           }
#'         }
#'       )
#'     }
#'   )
#' }
#'
progress <- function(...) {
  tags$div(
    class = "dull-progress progress",
    ...,
    bootstrap()
  )
}

#' @rdname progress
#' @export
bar <- function(value = 0, label = NULL, context = NULL, striped = FALSE,
                animated = FALSE, ...) {
  if (bad_context(context)) {
    stop(
      'invalid `progress` argument, `context` must be one of "success", ',
      '"info", "warning", or "danger"',
      call. = FALSE
    )
  }

  tags$div(
    class = collate(
      "dull-bar",
      "progress-bar",
      if (!is.null(context)) paste0("bg-", cxt),
      if (striped || animated) "progress-bar-striped"
    ),
    role = "progressbar",
    style = sprintf("width: %s%%", value),
    label,
    ...,
    bootstrap()
  )
}

#' @rdname progress
#' @export
renderBar <- function(value, label = NULL, env = parent.frame(), quoted = FALSE) {
  progressFun <- shiny::exprToFunction(value, env, quoted)
  labelFun <- shiny::exprToFunction(label, env, quoted)

  function() {
    list(
      value = progressFun(),
      label = labelFun()
    )
  }
}

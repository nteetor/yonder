#' Progress bars
#'
#' Create simple or composite progress bars. To create a composite progress bar
#' pass multiple calls to `bar` to a progress output. Each `bar` component has
#' its own id, value, label, and context.
#'
#' @param ... One or more `bar` elements passed to a progress output or named
#'   arguments passed as HTML attributes to the parent element.
#'
#' @param value An integer between 0 and 100 specifying the initial value
#'   of a bar.
#'
#' @param label A character string speciLabel(s) for a progress bar or components of a progress bar,
#'   defaults to `NULL`.
#'
#' @param striped If `TRUE`, the progress bar has a striped gradient, defaults
#'   to `FALSE`.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonInput(id = "inc", "Increment progress")
#'         ),
#'         col(
#'           progressOutput(
#'             bar(id = "clicks", value = 0) %>%
#'               background("light-blue")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$inc, {
#'         sendBar(
#'           id = "clicks",
#'           value = min(input$inc / 20 * 100, 100)
#'         )
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           progressOutput(
#'             bar(id = "faster", value = 0) %>%
#'               background("yellow"),
#'             bar(id = "slower", value = 0)
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         for (i in seq(from = 0, to = 50, by = 1)) {
#'           sendBar(
#'             id = "slower",
#'             value = i
#'           )
#'
#'           sendBar(
#'             id = "faster",
#'             value = min(i * 3, 50)
#'           )
#'
#'           Sys.sleep(0.1)
#'         }
#'       })
#'     }
#'   )
#' }
#'
progressOutput <- function(...) {
  tags$div(
    class = "dull-progress-output progress",
    ...,
    includes()
  )
}

#' @rdname progressOutput
#' @export
bar <- function(id, value, label = NULL, striped = FALSE, ...) {
  if (!is.character(id) && !is.null(id)) {
    stop(
      "invalid `bar` argument, `id` must be a character string or NULL",
      call. = FALSE
    )
  }

  value <- round(value)

  tags$div(
    class = collate(
      "dull-bar-output",
      "progress-bar",
      if (striped) "progress-bar-striped"
    ),
    id = id,
    role = "progressbar",
    style = paste0("width: ", value, "%"),
    `aria-valuemin` = "0",
    `aria-valuemax` = "100",
    label,
    ...
  )
}

#' @rdname progressOutput
#' @export
sendBar <- function(id, value, label = NULL,
                    session = getDefaultReactiveDomain()) {
  session$sendProgress(
    "dull-progress",
    dropNulls(
      list(
        id = id,
        value = value,
        label = label
      )
    )
  )
}

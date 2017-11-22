#' A range or slider input
#'
#' Create a range input.
#'
#' @param id A character string specifying the id of the range input.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           rangeInput("range1"),
#'           rangeInput("range2", context = "primary"),
#'           rangeInput("range3", context = "secondary"),
#'           rangeInput("range4", context = "success"),
#'           rangeInput("range5", context = "info", round = TRUE)
#'         ),
#'         col(
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
rangeInput <- function(id, context = NULL, round = FALSE) {
  tags$div(
    class = "dull-input dull-range-input form-group",
    tags$input(
      type = "range",
      id = id,
      class = collate(
        if (!is.null(context)) paste0("range-", context),
        if (round) "thumb-circle"
      )
    )
  )
}

#' Checkbar inputs
#'
#' Similar to a checkbox input.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           checkbarInput(
#'             id = "checkbar",
#'             choices = c(
#'               "Check 1 (pre-selected)",
#'               "Check 2",
#'               "Check 3"
#'             ),
#'             values = paste0("check", 1:3)
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       )
#'
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderPrint({
#'         input$checkbar
#'       })
#'     }
#'   )
#' }
checkbarInput <- function(id, choices, values = choices, selected = NULL,
                          label = NULL, context = "secondary") {
  # <div class="btn-group" data-toggle="buttons">
  #   <label class="btn btn-secondary active">
  #     <input type="checkbox" checked autocomplete="off"> Checkbox 1 (pre-checked)
  #   </label>
  #   <label class="btn btn-secondary">
  #     <input type="checkbox" autocomplete="off"> Checkbox 2
  #   </label>
  #   <label class="btn btn-secondary">
  #     <input type="checkbox" autocomplete="off"> Checkbox 3
  #   </label>
  # </div>

  selected <- match2(selected, values)

  tags$div(
    class = "dull-checkbar-input btn-group",
    `data-toggle` = "button",
    id = id,
    lapply(
      seq_along(choices),
      function(i) {
        tags$label(
          class = collate(
            "btn",
            paste0("btn-", context),
            if (selected[[i]]) "active"
          ),
          tags$input(
            type = "checkbox",
            autocomplete = "off",
            `data-value` = values[[i]],
            checked = if (selected[[i]]) NA
          ),
          choices[[i]]
        )
      }
    )
  )
}

radiobarInput <- function(id) {

}
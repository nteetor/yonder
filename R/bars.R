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
#'             values = c("check1", "check2", "check3"),
#'             selected = "check1"
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
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           radiobarInput(
#'             id = "radiobar",
#'             choices = c(
#'               "Radio 1 (pre-selected)",
#'               "Radio 2",
#'               "Radio 3"
#'             ),
#'             values = c("radio1", "radio2", "radio3"),
#'             selected = "radio1"
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
#'         input$radiobar
#'       })
#'     }
#'   )
#' }
#'
checkbarInput <- function(id, choices, values = choices, selected = NULL,
                          label = NULL, context = "secondary") {
  if (length(choices) != length(values)) {
    stop(
      "invalid `checkbarInput` arguments, `choices` and `values` must have ",
      "the same length",
      call. = FALSE
    )
  }

  if (!re(context, "secondary|success|info|warning|danger|link|primary", FALSE)) {
    stop(
      "invalid `checkbarInput` argument, `context` must be one of ",
      '"secondary", "primary", "success", "info", "warning", or "danger"',
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  tags$div(
    class = "dull-checkbar-input btn-group",
    `data-toggle` = "buttons",
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

#' @rdname checkbarInput
#' @export
radiobarInput <- function(id, choices, values = choices, selected = NULL,
                          label = NULL, context = "secondary") {
  if (length(choices) != length(values)) {
    stop(
      "invalid `radiobarInput` arguments, `choices` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  if (!re(context, "secondary|success|info|warning|danger|link|primary", FALSE)) {
    stop(
      "invalid `radiobarInput` argument, `context` must be one of ",
      '"secondary", "primary", "success", "info", "warning", or "danger"',
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  tags$div(
    class = "dull-radiobar-input btn-group",
    id = id,
    `data-toggle` = "buttons",
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
            name = id,
            type = "radio",
            `data-value` = values[[i]],
            autocomplete = "false",
            checked = if (selected[[i]]) NA
          ),
          choices[[i]]
        )
      }
    )
  )
}
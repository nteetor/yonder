#' Check- and radiobar inputs
#'
#' Checkbar and radiobar inputs behave like the counter parts, checkbox and
#' radio inputs. The -bar inputs are a stylistic variation. However, dull
#' checkbox inputs are singletons, thus the checkbar input is more akin to
#' shiny's checkbox group input.
#'
#'@param id A character string specifying the id of the check- or radiobar
#'   input.
#'
#' @param choices A character vector or flat list of character strings
#'   specifying the labels of the check- or radiobar options.
#'
#' @param values A character vector, flat list of character strings, or object
#'   to coerce to either, specifying the values of the check- or radiobar
#'   options, defaults to `choices`.
#'
#' @param selected One or more of `values` indicating which of the check- or
#'   radiobar options are selected by default, defaults to `NULL`, in which case
#'   there is no default option.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           checkbarInput(
#'             id = "lightblue",
#'             choices = c(
#'               "Check 1",
#'               "Check 2",
#'               "Check 3"
#'             ),
#'             selected = "Check 1"
#'           ) %>%
#'             background("light-blue", 1) %>%
#'             margins(2),
#'          checkbarInput(
#'             id = "indigo",
#'             choices = c(
#'               "Check 1",
#'               "Check 2",
#'               "Check 3"
#'             ),
#'             selected = "Check 2"
#'           ) %>%
#'             background("indigo", 1) %>%
#'             margins(2)
#'         ),
#'         col(
#'           verbatimTextOutput("values")
#'         )
#'       )
#'
#'     ),
#'     server = function(input, output) {
#'       output$values <- renderPrint({
#'         list(
#'           `light-blue` = input$lightblue,
#'           indigo = input$indigo
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
#'           radiobarInput(
#'             id = "radiobar",
#'             choices = c(
#'               "Radio 1",
#'               "Radio 2",
#'               "Radio 3"
#'             ),
#'             selected = "Radio 1"
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
checkbarInput <- function(id, choices, values = choices, selected = NULL) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `checkbarInput` arguments, `choices` and `values` must have ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  tags$div(
    class = collate(
      "dull-checkbar-input",
      if (length(choices) > 1) "btn-group",
      "btn-group-toggle",
      "bg-grey"
    ),
    `data-toggle` = "buttons",
    id = id,
    lapply(
      seq_along(choices),
      function(i) {
        tags$label(
          class = collate(
            "btn",
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
radiobarInput <- function(id, choices, values = choices, selected = NULL) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `radiobarInput` arguments, `choices` and `values` must be ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  tags$div(
    class = "dull-radiobar-input btn-group btn-group-toggle bg-grey",
    id = id,
    `data-toggle` = "buttons",
    lapply(
      seq_along(choices),
      function(i) {
        tags$label(
          class = collate(
            "btn",
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

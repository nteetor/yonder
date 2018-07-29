#' Check- and radiobar inputs
#'
#' Checkbar and radiobar inputs behave like the counter parts, checkbox and
#' radio inputs. The -bar inputs are a stylistic variation. However, yonder
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
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           checkbarInput(
#'             id = "blue",
#'             choices = c(
#'               "Check 1",
#'               "Check 2",
#'               "Check 3"
#'             ),
#'             selected = "Check 1"
#'           ) %>%
#'             background("blue") %>%
#'             margin(2),
#'          checkbarInput(
#'             id = "indigo",
#'             choices = c(
#'               "Check 1",
#'               "Check 2",
#'               "Check 3"
#'             ),
#'             selected = "Check 2"
#'           ) %>%
#'             background("indigo") %>%
#'             margin(2)
#'         ),
#'         column(
#'           verbatimTextOutput("values")
#'         )
#'       )
#'
#'     ),
#'     server = function(input, output) {
#'       output$values <- renderPrint({
#'         list(
#'           `blue` = input$blue,
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
#'         column(
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
#'         column(
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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       checkbarInput("foo", c("hello, world!", "goodnight, moon"), c("world", "moon")),
#'       textOutput("selected"),
#'       buttonInput("labels", "Change labels"),
#'       buttonInput("values", "Change values")
#'     ),
#'     server = function(input, output) {
#'       output$selected <- renderPrint({
#'         input$foo
#'       })
#'
#'       observeEvent(input$labels, {
#'         updateChoices("foo", world = "goodbye, world!", moon = "morning, moon")
#'       })
#'
#'       observeEvent(input$values, {
#'         updateValues("foo", world = "planet", moon = "spacestation")
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
      "yonder-checkbar",
      if (length(choices) > 1) "btn-group",
      "btn-group-toggle"
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
          tags$span(
            choices[[i]]
          )
        )
      }
    )
  )
}

#' @family inputs
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
    class = "yonder-radiobar btn-group btn-group-toggle",
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
          tags$span(
            choices[[i]]
          )
        )
      }
    )
  )
}

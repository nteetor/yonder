---
layout: page
slug: show-alert
roxygen:
  rdname: ~
  name: showAlert
  doctype: ~
  title: Static and actionable alerts
  description: |-
    Use `showAlert` to let the user know of successes or to call attention to
    problems. While alerts are static by default they can also be made
    actionable. Actionable alerts can be used for undoing or redoing an action
    and more.
  parameters:
  - name: text
    description: A character string specifying the message text of the alert.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      alert element.
  - name: duration
    description: |-
      A positive integer or `NULL` specifying the duration of the
      alert, by default the alert is removed after 4 seconds. If `NULL` the
      alert is not automatically removed.
  - name: color
    description: |-
      A character string specifying the color of the alert,
      for possible colors see [background].
  - name: action
    description: |-
      A character string specifying a reactive id. If specified a
      button is added to the alert. If clicked the reactive value
      `input[[action]]` is set to `TRUE`. When the alert is removed
      `input[[action]]` is reset to `NULL`.
  sections: ~
  examples:
  - |-
    if (interactive()) {
      shinyApp(
        ui = container(
          buttonInput("show", "Alert!") %>%
            margins(3)
        ),
        server = function(input, output) {
          observeEvent(input$show, {
            color <- sample(c("teal", "red", "orange", "blue"), 1)
            showAlert("Alert", color = color)
          })
        }
      )
    }
  - |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              groupInput(
                id = "text",
                right = buttonInput("clear", fontAwesome("times")) %>%
                  background("red", -1)
              )
            ),
            col(
              verbatimTextOutput("value")
            )
          ) %>%
            margins(3)
        ),
        server = function(input, output) {
          oldValue <- NULL

          output$value <- renderPrint(input$text)

          observeEvent(input$clear, {
            oldValue <<- input$text
            updateValues("text", "")
            showAlert("Undo clear.", color = "yellow", action = "undo")
          })

          observeEvent(input$undo, {
            updateValues("text", oldValue)
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: alerts.R
  source: "showAlert <- function(text, ..., duration = 4, color = NULL, \n    action
    = NULL) {\n    domain <- getDefaultReactiveDomain()\n    if (is.null(domain))
    {\n        stop(\"function `showAlert()` must be called in a reactive context\",
    \n            call. = FALSE)\n    }\n    if (!is.null(color) && !(color %in% .colors))
    {\n        stop(\"invalid `showAlert()` argument, unrecognized `color` , see ?background
    \", \n            \"for possible values\", call. = FALSE)\n    }\n    text <-
    as.character(text)\n    if (length(text) != 1) {\n        stop(\"invalid `showAlert()`
    argument, expecting `text` to be a character \", \n            \"string\", call.
    = FALSE)\n    }\n    if (!is.null(duration)) {\n        if (!is.numeric(duration)
    || duration <= 0) {\n            stop(\"invalid `showAlert()` argument, expecting
    `duration` to be a positive \", \n                \"integer or NULL\", call. =
    FALSE)\n        }\n    }\n    args <- list(...)\n    attrs <- attribs(args)\n
    \   domain$sendInputMessage(\"alert-container\", list(type = \"show\", \n        data
    = list(text = text, duration = if (!is.null(duration)) duration * \n            1000,
    color = color, action = action, attrs = if (length(attrs)) attrs)))\n}"
---

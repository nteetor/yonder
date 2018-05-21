---
layout: page
slug: close-alert
roxygen:
  rdname: showAlert
  name: closeAlert
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples:
  - |-
    if (interactive()) {
      shinyApp(
        ui = container(
          buttonInput("add", "Alert") %>%
            margin(3),
          buttonInput("first", "Remove first alert"),
          buttonInput(
            id = "reds",
            label = "Remove red alerts",
            alt = "the red ones offend the aesthetic"
          ),
          buttonInput("alert", "Remove 'Alert' alerts")
        ),
        server = function(input, output) {
          observeEvent(input$add, {
            color <- sample(c("grey", "teal", "purple", "yellow", "red"), 1)
            showAlert("Alert", duration = NULL, color = color)
          })

          observeEvent(input$first, {
            closeAlert(1)
          })

          observeEvent(input$reds, {
            closeAlert(class = "alert-red")
          })

          observeEvent(input$alert, {
            closeAlert("Alert")
          })
        }
      )
    }
  - |
    # this is a variation of the second example
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              groupInput(
                id = "text",
                right = buttonInput("clear", icon("times")) %>%
                  background("red")
              )
            ),
            column(
              verbatimTextOutput("value")
            )
          ) %>%
            margin(3)
        ),
        server = function(input, output) {
          oldValue <- NULL

          output$value <- renderPrint(input$text)

          observeEvent(input$clear, {
            oldValue <<- input$text
            updateValues("text", "")
            showAlert(
              text = "Undo clear.",
              color = "yellow",
              action = "undo",
              duration = NULL
            )
          })

          observeEvent(input$undo, {
            updateValues("text", oldValue)
            closeAlert(1)
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: alerts.R
  source: "closeAlert <- function(...) {\n    domain <- getDefaultReactiveDomain()\n
    \   if (is.null(domain)) {\n        stop(\"function `closeAlert()` must be called
    in a reactive context\", \n            call. = FALSE)\n    }\n    args <- dots_list(...)\n
    \   elems <- elements(args)\n    attrs <- attribs(args)\n    indeces <- elems[vapply(elems,
    is.numeric, logical(1))]\n    if (length(indeces)) {\n        if (any(unlist(indeces)%%1
    != 0)) {\n            stop(\"invalid `closeAlert()` argument, indeces must be
    whole numbers\", \n                call. = FALSE)\n        }\n        indeces
    <- lapply(indeces, `-`, 1)\n    }\n    if (!is.null(attrs[[\"class\"]]) && length(attrs[[\"class\"]])
    > \n        1) {\n        attrs[[\"class\"]] <- paste(attrs[[\"class\"]], collapse
    = \" \")\n    }\n    domain$sendInputMessage(\"alert-container\", list(type =
    \"close\", \n        data = list(text = elems[vapply(elems, is.character, \n            logical(1))],
    index = indeces, attrs = attrs)))\n}"
---

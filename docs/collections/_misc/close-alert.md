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
            margins(3),
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
  source:
  - closeAlert <- function(...) {
  - '  domain <- getDefaultReactiveDomain()'
  - '  if (is.null(domain)) {'
  - '    stop('
  - '      "function `closeAlert()` must be called in a reactive context",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  args <- dots_list(...)'
  - '  elems <- elements(args)'
  - '  attrs <- attribs(args)'
  - '  indeces <- elems[vapply(elems, is.numeric, logical(1))]'
  - '  if (length(indeces)) {'
  - '    if (any(unlist(indeces) %% 1 != 0)) {'
  - '      stop('
  - '        "invalid `closeAlert()` argument, indeces must be whole numbers",'
  - '        call. = FALSE'
  - '      )'
  - '    }'
  - '    indeces <- lapply(indeces, `-`, 1)'
  - '  }'
  - '  if (!is.null(attrs[["class"]]) && length(attrs[["class"]]) >'
  - '    1) {'
  - '    attrs[["class"]] <- paste(attrs[["class"]], collapse = " ")'
  - '  }'
  - '  domain$sendInputMessage("alert-container", list('
  - '    type = "close",'
  - '    data = list(text = elems[vapply('
  - '      elems, is.character,'
  - '      logical(1)'
  - '    )], index = indeces, attrs = attrs)'
  - '  ))'
  - '}'
---

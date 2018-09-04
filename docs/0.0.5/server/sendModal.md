---
this: sendModal
filename: R/modal.R
layout: page
roxygen:
  title: Modal dialogs
  description: |-
    Modals are a flexible alert window, which disable interaction with the page
    behind them. Modals may include inputs or buttons or simply include text.
  parameters:
  - name: title
    description: A character string specifying the modal's title.
  - name: body
    description: |-
      A character string specifying the body of the modal or
      custom element to use as the body of the modal, defaults to `NULL`.
  - name: footer
    description: |-
      Custom tags to include at the bottom of the modal, defaults to
      `NULL`.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain()](/yonder/0.0.5/getDefaultReactiveDomain().html).
  sections: ~
  return: ~
  family: server
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            buttonInput(id = "button", "Click to show modal")
          ),
          server = function(input, output) {
            observeEvent(input$button, {
              sendModal(
                title = "A simple modal",
                body = paste(
                  "Cras mattis consectetur purus sit amet fermentum.",
                  "Cras justo odio, dapibus ac facilisis in, egestas",
                  "eget quam. Morbi leo risus, porta ac consectetur",
                  "ac, vestibulum at eros."
                )
              )
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              class = "justify-content-center",
              column(
                buttonInput(id = "trigger", "Trigger modal")
              )
            )
          ),
          server = function(input, output) {
            observeEvent(input$trigger, {
              sendModal(
                title = "Login",
                body = loginInput("login")
              )
            })
            observeEvent(input$login, {
              if (input$login$username != "" && input$login$password != "") {
                closeModal()
              }
            })
          }
        )
      }
    output: []
---

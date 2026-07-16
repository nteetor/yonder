# Demo app for input_text() / update_text().
#
# Exercises the new TextInputBinding (srcts/src/components/inputText.ts):
#
#   1. Typing is debounced (250ms): mash keys in the input — the value and
#      update counter should settle once you pause, not fire per keystroke.
#   2. Committed changes are immediate: blur the input (Tab or click away)
#      and the value updates right away, no debounce delay.
#   3. Server updates apply immediately: "Set value" pushes a new value via
#      update_text(value = ...).
#   4. Disabling works: the checkbox toggles update_text(disable = ...).

library(yonder)
library(bslib)

shinyApp(
  ui = page_fluid(
    title = "input_text() demo",
    layout_columns(
      card(
        card_header("Text input"),
        input_text(
          id = "name",
          placeholder = "Type here"
        ),
        verbatimTextOutput("value"),
        verbatimTextOutput("updates")
      ),
      card(
        card_header("Server updates"),
        input_button(
          id = "set",
          text = "Set value to 'hello, world'"
        ),
        input_checkbox(
          id = "disable",
          choice = "Disable input"
        )
      )
    )
  ),
  server = function(input, output, session) {
    output$value <- renderPrint({
      input$name
    })

    # With debouncing, rapid typing should produce far fewer updates than
    # keystrokes.
    updates <- reactiveVal(0)

    observeEvent(input$name, ignoreInit = TRUE, {
      updates(updates() + 1)
    })

    output$updates <- renderPrint({
      paste("updates received:", updates())
    })

    observeEvent(input$set, {
      update_text(
        id = "name",
        value = "hello, world"
      )
    })

    observeEvent(input$disable, ignoreInit = TRUE, {
      update_text(
        id = "name",
        disable = isTRUE(input$disable)
      )
    })
  }
)

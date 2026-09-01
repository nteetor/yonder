# Demo app for collapse_panel() / the bsides.collapse binding.
#
# Exercises srcts/src/components/collapse.ts:
#
#   1. The panel reports its state: input$details reads "closed" or "open",
#      and updates once the slide finishes — never mid-animation.
#   2. Server functions drive the panel: open_collapse_panel(),
#      close_collapse_panel(), and toggle_collapse_panel() each reach the
#      client, and the value above follows.
#   3. Triggers stay in sync: however the panel was moved, the trigger
#      button's aria-expanded and .collapsed class match the panel.

library(yonder)
library(bslib)

shinyApp(
  ui = page_fluid(
    title = "collapse_panel() demo",
    layout_columns(
      card(
        card_header("Panel"),
        collapse_panel_button(target = "details", text = "Details"),
        collapse_panel(
          id = "details",
          card(
            card_body(
              "Collapse panels hide content until it is wanted. This one",
              "answers to its button and to the server alike."
            )
          )
        ),
        verbatimTextOutput("state")
      ),
      card(
        card_header("Server"),
        input_button(id = "open", label = "Open"),
        input_button(id = "close", label = "Close"),
        input_button(id = "toggle", label = "Toggle")
      )
    )
  ),
  server = function(input, output, session) {
    output$state <- renderPrint({
      input$details
    })

    observeEvent(input$open, {
      open_collapse_panel("details")
    })

    observeEvent(input$close, {
      close_collapse_panel("details")
    })

    observeEvent(input$toggle, {
      toggle_collapse_panel("details")
    })
  }
)

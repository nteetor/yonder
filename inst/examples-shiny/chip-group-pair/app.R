# Minimal repro app: two chip group inputs stacked in a single card, to
# inspect rendering behavior when the inputs share a container.

library(yonder)
library(bslib)

shinyApp(
  ui = page_fluid(
    title = "Two chip groups, one card",
    card(
      card_header("Two chip groups"),
      input_chip_group(
        id = "colors",
        choices = c("Red", "Green", "Blue"),
        values = c("r", "g", "b")
      ),
      input_chip_group(
        id = "sizes",
        choices = c("Small", "Medium", "Large"),
        values = c("s", "m", "l"),
        select = c("s", "l"),
        type = "warning"
      ),
      verbatimTextOutput("values")
    )
  ),
  server = function(input, output, session) {
    output$values <- renderPrint({
      list(colors = input$colors, sizes = input$sizes)
    })
  }
)

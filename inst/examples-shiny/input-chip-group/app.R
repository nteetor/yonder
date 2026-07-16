# Demo app for input_chip_group() / <bsides-chip-group>.
#
# Three cards (see plan-chip-input.md):
#
#   1. Toggle chips: click a chip (or press Enter/Space on it) to toggle
#      its checked state. input$colors is the checked set — NULL when
#      nothing is checked. select = NULL starts all chips unchecked (the
#      default, select = values, would start them all checked).
#
#   2. Initial selection + type: select names the values that start
#      checked; type colors the chips.
#
#   3. Server updates: update_chip_group() replaces the selection (no
#      merging), clears it, swaps the choices (checked values whose chip
#      disappears fall out of the value), and disables/enables the input.

library(yonder)
library(bslib)

shinyApp(
  ui = page_fluid(
    title = "input_chip_group() demo",
    layout_columns(
      col_widths = c(6, 6, 12),
      card(
        card_header("Toggle chips"),
        input_chip_group(
          id = "colors",
          choices = c("Red", "Green", "Blue"),
          values = c("r", "g", "b"),
          select = NULL
        ),
        verbatimTextOutput("colors_value")
      ),
      card(
        card_header("Initial selection + type"),
        input_chip_group(
          id = "sizes",
          choices = c("Small", "Medium", "Large"),
          values = c("s", "m", "l"),
          select = c("s", "l"),
          type = "success"
        ),
        verbatimTextOutput("sizes_value")
      ),
      card(
        card_header("Server updates"),
        input_button(id = "set", text = "Select red + blue"),
        input_button(id = "clear", text = "Clear selection"),
        input_button(id = "swap", text = "Swap size choices"),
        input_checkbox(id = "disable", choice = "Disable colors input")
      )
    )
  ),
  server = function(input, output, session) {
    output$colors_value <- renderPrint({
      input$colors
    })

    output$sizes_value <- renderPrint({
      input$sizes
    })

    observeEvent(input$set, {
      update_chip_group("colors", select = c("r", "b"))
    })

    observeEvent(input$clear, {
      update_chip_group("colors", select = character(0))
    })

    observeEvent(input$swap, {
      update_chip_group(
        "sizes",
        choices = c("Medium", "Giant"),
        values = c("m", "xl")
      )
    })

    observeEvent(input$disable, ignoreInit = TRUE, {
      if (isTRUE(input$disable)) {
        update_chip_group("colors", disable = TRUE)
      } else {
        update_chip_group("colors", enable = TRUE)
      }
    })
  }
)

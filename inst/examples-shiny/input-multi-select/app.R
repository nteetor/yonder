# Demo app for input_multi_select() / <bsides-multi-select>.
#
# Four cards (see plan-multi-select-input.md):
#
#   1. Choices mode (edit = "choices", the default): selected values render
#      as chips inside the bordered field, alongside the text entry.
#      Clicking anywhere in the field opens the dropdown, which lists all
#      choices with a checkmark beside current selections — picking a
#      checked option removes it, picking an unchecked one adds it. Type to
#      filter, arrows + Enter or click to pick. Free text is rejected.
#
#   2. Free mode (edit = "free", no choices): typed text becomes chips —
#      the tag entry input. Backspace in the empty input removes the last
#      chip.
#
#   3. Horizontal layout: the field stays one chip high; chips scroll
#      sideways under the pinned caret instead of wrapping.
#
#   4. Server updates: update_multi_select() replaces the selection, swaps
#      choices (selections no longer offered are pruned), changes the
#      placeholder (visible only while the field is empty), and
#      disables/enables the input.

library(yonder)
library(bslib)

shinyApp(
  ui = page_fluid(
    title = "input_multi_select() demo",
    layout_columns(
      col_widths = c(6, 6, 8, 12),
      card(
        card_header("Choices"),
        input_multi_select(
          id = "countries",
          choices = c("Belgium", "Brazil", "Canada", "Japan", "Norway"),
          values = c("be", "br", "ca", "jp", "no"),
          select = "ca",
          placeholder = "Pick countries"
        ),
        verbatimTextOutput("countries_value")
      ),
      card(
        card_header("Free (tag entry)"),
        input_multi_select(
          id = "tags",
          edit = "free",
          placeholder = "Add a tag, press Enter"
        ),
        verbatimTextOutput("tags_value")
      ),
      card(
        card_header("Horizontal (one row, scrolls)"),
        input_multi_select(
          id = "crew",
          choices = c(
            "Amundsen",
            "Earhart",
            "Gagarin",
            "Hillary",
            "Kingsford Smith",
            "Magellan",
            "Norgay",
            "Piccard",
            "Ride",
            "Shackleton",
            "Tereshkova"
          ),
          select = c(
            "Amundsen",
            "Earhart",
            "Gagarin",
            "Hillary",
            "Kingsford Smith",
            "Magellan",
            "Norgay",
            "Piccard",
            "Ride",
            "Shackleton",
            "Tereshkova"
          ),
          layout = "horizontal",
          type = "success"
        ),
        verbatimTextOutput("crew_value")
      ),
      card(
        card_header("Server updates"),
        input_button(id = "set", text = "Select Belgium + Japan"),
        input_button(id = "swap", text = "Swap choices (prunes)"),
        input_button(id = "hint", text = "Change placeholder"),
        input_checkbox(id = "disable", choice = "Disable countries input")
      )
    )
  ),
  server = function(input, output, session) {
    output$countries_value <- renderPrint({
      input$countries
    })

    output$tags_value <- renderPrint({
      input$tags
    })

    output$crew_value <- renderPrint({
      input$crew
    })

    observeEvent(input$set, {
      update_multi_select("countries", select = c("be", "jp"))
    })

    observeEvent(input$swap, {
      update_multi_select(
        "countries",
        choices = c("Belgium", "Brazil", "Mexico", "Kenya"),
        values = c("be", "br", "mx", "ke")
      )
    })

    observeEvent(input$hint, {
      update_multi_select("countries", placeholder = "Fresh placeholder")
    })

    observeEvent(input$disable, ignoreInit = TRUE, {
      if (isTRUE(input$disable)) {
        update_multi_select("countries", disable = TRUE)
      } else {
        update_multi_select("countries", enable = TRUE)
      }
    })
  }
)

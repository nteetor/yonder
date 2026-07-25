# Demo app for input labels.
#
# Covers the three ways an input gets labelled:
#
#   1. Standard labels — `label = "text"` renders a <label for> ahead of the
#      input, or a <fieldset>/<legend> for group inputs and custom elements,
#      which `for` cannot target.
#   2. Floating labels — `label = floating_label("text")` renders Bootstrap's
#      .form-floating markup. Only the .form-control / .form-select inputs
#      support it; every other input errors rather than degrading silently.
#   3. Label updating — only inputs whose own content IS their label can have
#      it changed from the server: button, link, menu, and form submit. See
#      the note in the "Updating" card.

library(yonder)
library(bslib)

shinyApp(
  ui = page_fluid(
    title = "Input labels",
    tags$style(
      "fieldset { margin-bottom: 1rem; } .demo-stack > * { margin-bottom: 1rem; }"
    ),
    layout_columns(
      col_widths = c(6, 6),

      card(
        card_header("Standard labels"),
        class = "demo-stack",
        input_text(
          id = "std_text",
          label = "Text input"
        ),
        input_numeric(
          id = "std_numeric",
          label = "Numeric input",
          value = 10
        ),
        input_select(
          id = "std_select",
          label = "Select input",
          choices = c("Alpha", "Beta", "Gamma")
        ),
        input_text_group(
          id = "std_text_group",
          label = "Text group input",
          left = "@"
        ),
        verbatimTextOutput("standard_values")
      ),

      card(
        card_header("Floating labels"),
        class = "demo-stack",
        p(
          class = "text-muted small",
          "Click into an input, or type, to float the label. The select",
          "floats immediately — it always has a value."
        ),
        input_text(
          id = "flt_text",
          label = floating_label("Text input")
        ),
        input_numeric(
          id = "flt_numeric",
          label = floating_label("Numeric input")
        ),
        input_select(
          id = "flt_select",
          label = floating_label("Select input"),
          choices = c("Alpha", "Beta", "Gamma")
        ),
        input_text_group(
          id = "flt_text_group",
          label = floating_label("Text group input"),
          left = "@"
        ),
        verbatimTextOutput("floating_values")
      ),

      card(
        card_header("Group inputs — fieldset and legend"),
        class = "demo-stack",
        p(
          class = "text-muted small",
          "A group has no single control for <label for> to point at, so a",
          "<fieldset> with a <legend> labels the set. Passing a",
          "floating_label() to any of these is an error."
        ),
        input_checkbox_group(
          id = "grp_checkbox",
          label = "Checkbox group",
          choices = c("One", "Two", "Three")
        ),
        input_radio_group(
          id = "grp_radio",
          label = "Radio group",
          choices = c("Red", "Green"),
          layout = "row"
        ),
        input_chip_group(
          id = "grp_chip",
          label = "Chip group",
          choices = c("Tag A", "Tag B")
        ),
        verbatimTextOutput("group_values")
      ),

      card(
        card_header("choice_placement"),
        class = "demo-stack",
        p(
          class = "text-muted small",
          "Where a choice's text sits relative to its checkbox. Ignored when",
          "appearance is \"buttons\" — there the text is the button and no",
          "checkbox renders."
        ),
        input_checkbox_group(
          id = "place_after",
          label = "choice_placement = \"after\" (default)",
          choices = c("One", "Two")
        ),
        input_checkbox_group(
          id = "place_before",
          label = "choice_placement = \"before\"",
          choices = c("One", "Two"),
          choice_placement = "before"
        ),
        input_checkbox_group(
          id = "place_buttons",
          label = "appearance = \"buttons\" (placement ignored)",
          choices = c("One", "Two"),
          appearance = "buttons",
          choice_placement = "before"
        )
      ),

      card(
        card_header("Updating"),
        class = "demo-stack",
        p(
          class = "text-muted small",
          "Only inputs whose own content is their label can be relabelled",
          "from the server. There is no update path for the external labels",
          "in the cards above — no update_*() function takes a `label`",
          "meaning \"the text beside this input\"."
        ),
        input_button(
          id = "upd_button",
          label = "Button label"
        ),
        tags$div(
          input_link(
            id = "upd_link",
            label = "Link label"
          )
        ),
        input_menu(
          id = "upd_menu",
          label = "Menu label",
          choices = c("One", "Two")
        ),
        tags$hr(),
        input_button(
          id = "relabel",
          label = "Relabel all three"
        ),
        input_button(
          id = "reset",
          label = "Reset labels"
        ),
        verbatimTextOutput("update_values")
      )
    )
  ),
  server = function(input, output, session) {
    output$standard_values <- renderPrint({
      list(
        text = input$std_text,
        numeric = input$std_numeric,
        select = input$std_select,
        text_group = input$std_text_group
      )
    })

    output$floating_values <- renderPrint({
      list(
        text = input$flt_text,
        numeric = input$flt_numeric,
        select = input$flt_select,
        text_group = input$flt_text_group
      )
    })

    output$group_values <- renderPrint({
      list(
        checkbox = input$grp_checkbox,
        radio = input$grp_radio,
        chip = input$grp_chip
      )
    })

    output$update_values <- renderPrint({
      list(
        button = input$upd_button,
        link = input$upd_link,
        menu = input$upd_menu
      )
    })

    observeEvent(input$relabel, {
      update_button(id = "upd_button", label = "Relabelled button")
      update_link(id = "upd_link", label = "Relabelled link")
      update_menu_input(id = "upd_menu", label = "Relabelled menu")
    })

    observeEvent(input$reset, {
      update_button(id = "upd_button", label = "Button label")
      update_link(id = "upd_link", label = "Link label")
      update_menu_input(id = "upd_menu", label = "Menu label")
    })
  }
)

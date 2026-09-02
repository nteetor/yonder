# Deliberately busy demo: every input in the package on one screen, all
# of it live, much of it wired to something else. Nothing here is a
# layout recommendation -- it is a stress test for the components and a
# reminder of what "too much" looks like.
#
# Cross-wiring worth knowing about before you poke at it:
#
#   * the "Chaos" range drives the numeric, the progress-ish badges, and
#     how many rows the list group shows
#   * the "Lock everything" switch disables half the inputs at once
#   * the radio group swaps the checkbox group's appearance, so the same
#     choices redraw as buttons, switches, or list rows
#   * the menu picks a theme name that retitles the modal
#   * every input echoes into the console card at the bottom right

library(yonder)
library(bslib)

languages <- c("C", "JavaScript", "Python", "R", "Rust", "SQL")
regions <- c("North", "South", "East", "West")
severities <- c("info", "warning", "danger", "success")

shinyApp(
  ui = page_fluid(
    title = "yonder kitchen sink",
    tags$style(HTML(
      ".card { margin-bottom: .5rem; }
       .card-body { padding: .6rem; }
       .card-header { padding: .3rem .6rem; font-size: .8rem;
                      text-transform: uppercase; letter-spacing: .04em; }
       pre { font-size: .7rem; margin: 0; max-height: 9rem; }
       .ticker { font-variant-numeric: tabular-nums; }"
    )),
    d4("Everything, all at once", badge("v0.2.0", appearance = "pill")),
    alert(
      "Six of these inputs update each other. Good luck.",
      type = "warning"
    ),
    layout_columns(
      col_widths = c(3, 3, 3, 3),
      card(
        card_header("Text"),
        input_text(
          id = "name",
          label = "Name",
          placeholder = "Ada Lovelace"
        ),
        input_text_group(
          id = "handle",
          label = "Handle",
          left = "@",
          right = badge("live"),
          value = "yonder"
        ),
        input_text(
          id = "floater",
          label = floating_label("Floating label")
        )
      ),
      card(
        card_header("Numbers"),
        input_range(
          id = "chaos",
          label = "Chaos",
          min = 0,
          max = 100,
          value = 40
        ),
        input_numeric(
          id = "chaos_exact",
          label = "Chaos, exactly",
          value = 40,
          min = 0,
          max = 100
        ),
        uiOutput("gauge")
      ),
      card(
        card_header("Pick one"),
        input_radio_group(
          id = "appearance",
          label = "Checkbox appearance",
          choices = c("default", "buttons", "switches", "list"),
          select = "default",
          appearance = "buttons",
          layout = "row"
        ),
        input_select(
          id = "region",
          label = "Region",
          choices = regions
        )
      ),
      card(
        card_header("Pick many"),
        input_checkbox_group(
          id = "features",
          label = "Features",
          choices = c("Alerts", "Badges", "Chips", "Modals"),
          select = c("Alerts", "Chips")
        ),
        input_checkbox(
          id = "lock",
          choice = "Lock everything",
          value = FALSE
        )
      )
    ),
    layout_columns(
      col_widths = c(3, 3, 3, 3),
      card(
        card_header("Chips"),
        input_chip_group(
          id = "stack",
          label = "Stack",
          choices = languages,
          select = c("R", "SQL"),
          type = "primary"
        ),
        input_multi_select(
          id = "languages",
          label = "Languages",
          choices = languages,
          select = "R",
          placeholder = "Type to filter"
        ),
        input_multi_select(
          id = "tags",
          label = "Free tags",
          edit = "free",
          placeholder = "Enter to add"
        )
      ),
      card(
        card_header("Lists and menus"),
        input_list_group(
          id = "rows",
          label = NULL,
          choices = c("Alpha", "Beta", "Gamma", "Delta", "Epsilon"),
          select = "Beta",
          appearance = "flush"
        ),
        input_menu(
          id = "theme",
          label = "Theme",
          choices = c("Slate", "Solar", "Flatly", "Cyborg")
        )
      ),
      card(
        card_header("Buttons and links"),
        button_toolbar(
          button_group(
            input_button(id = "left", label = "Left"),
            input_button(id = "middle", label = "Middle"),
            input_button(id = "right", label = "Right")
          )
        ),
        input_link(id = "more", label = "Tell me more"),
        modal_button(id = "detail", text = "Open modal"),
        collapse_panel_button(target = "extras", text = "More controls"),
        collapse_panel(
          id = "extras",
          input_file(
            id = "upload",
            label = "Upload",
            select = "many",
            placeholder = "Drop files"
          )
        )
      ),
      card(
        card_header("Form"),
        input_form(
          id = "signup",
          input_text(id = "email", label = "Email"),
          input_select(
            id = "plan",
            label = "Plan",
            choices = c("Free", "Pro", "Enterprise")
          ),
          form_submit_button(label = "Sign up")
        )
      )
    ),
    layout_columns(
      col_widths = c(4, 4, 4),
      card(
        card_header("Ticker"),
        div(class = "ticker", uiOutput("ticker"))
      ),
      card(
        card_header("Noise"),
        uiOutput("noise")
      ),
      card(
        card_header("Console"),
        verbatimTextOutput("console")
      )
    ),
    modal_dialog(
      id = "detail",
      size = "lg",
      modal_header(modal_title(textOutput("modal_title", inline = TRUE))),
      modal_body(
        placeholder_block(lines = 4, animate = "wave"),
        input_radio_group(
          id = "severity",
          label = "Alert severity",
          choices = severities,
          select = "info",
          layout = "row"
        )
      ),
      modal_footer()
    )
  ),
  server = function(input, output, session) {
    # range <-> numeric, each nudging the other
    observeEvent(input$chaos, {
      if (!identical(input$chaos_exact, input$chaos)) {
        update_numeric(id = "chaos_exact", value = input$chaos)
      }
    })

    observeEvent(input$chaos_exact, {
      if (!identical(input$chaos, input$chaos_exact)) {
        update_range(id = "chaos", value = input$chaos_exact)
      }
    })

    # one switch disables a pile of inputs
    observeEvent(input$lock, {
      locked <- isTRUE(input$lock)
      update_text(id = "name", disable = locked)
      update_text_group(id = "handle", disable = locked)
      update_range(id = "chaos", disable = locked)
      update_numeric(id = "chaos_exact", disable = locked)
      update_select(id = "region", disable = locked)
      update_multi_select(id = "languages", disable = locked)
      update_button(id = "left", disable = locked)
      update_button(id = "middle", disable = locked)
      update_button(id = "right", disable = locked)
    })

    # radio group rewrites the checkbox group under it
    observeEvent(input$appearance, {
      update_radio_group(
        id = "severity",
        appearance = input$appearance,
        layout = "row"
      )
    })

    # the list group grows and shrinks with the range
    observeEvent(input$chaos, {
      n <- max(1, min(5, ceiling(input$chaos / 20)))
      update_list_group(
        id = "rows",
        choices = c("Alpha", "Beta", "Gamma", "Delta", "Epsilon")[seq_len(n)]
      )
    })

    # the menu retitles the modal
    output$modal_title <- renderText({
      paste(input$theme %||% "Untitled", "details")
    })

    # a badge row standing in for a progress bar
    output$gauge <- renderUI({
      filled <- max(0, min(10, round((input$chaos %||% 0) / 10)))
      div(
        lapply(seq_len(10), function(i) {
          badge(
            class = if (i <= filled) "text-bg-primary" else "text-bg-light",
            HTML("&nbsp;")
          )
        })
      )
    })

    # something moving, because a busy screen needs a moving part
    ticker <- reactiveTimer(700)

    counter <- reactiveVal(0)

    observeEvent(ticker(), {
      counter(counter() + 1)
    })

    output$ticker <- renderUI({
      n <- counter()
      div(
        d5(n),
        badge(
          class = "text-bg-info",
          sprintf("%s ticks", n),
          appearance = "pill"
        ),
        badge(
          class = "text-bg-secondary",
          format(Sys.time(), "%H:%M:%S")
        )
      )
    })

    output$noise <- renderUI({
      ticker()
      severity <- input$severity %||% "info"
      alert(
        sprintf(
          "Chaos %s, %s selected, %s features on.",
          input$chaos %||% 0,
          length(input$languages %||% character()),
          length(input$features %||% character())
        ),
        type = severity,
        dismiss = "none"
      )
    })

    output$console <- renderPrint({
      str(reactiveValuesToList(input), max.level = 1, give.attr = FALSE)
    })

    observeEvent(input$signup, {
      showNotification(
        sprintf("Signed up %s", input$email %||% "nobody")
      )
    })
  }
)

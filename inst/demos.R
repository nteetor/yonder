# button input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_button(
      id = "count",
      label = "Count"
    )
  ),
  server = function(input, output) {
    observe({
      print(input$count)
    })
  }
)

# chip input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_chip(
      id = "testchip",
      choices = c("Choice 1", "Choice 2 ")
    )
  ),
  server = function(input, output) {}
)

# checkbox button input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_checkbox_button(
      id = "greetings",
      choices = c("Hello", "Howdy", "Hey there")
    )
  ),
  server = function(input, output) {
    observe({
      update_checkbox_button(
        id = "greetings",
        select = "Howdy",
        disable = "Hey there"
      )
    })
  }
)


# checkbox input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    shiny::actionButton(
      inputId = "swap",
      label = "Swap"
    ),
    input_checkbox(
      id = "check",
      choices = c("Left", "Right")
    )
  ),
  server = function(input, output) {
    LAYOUTS <- c("column", "row")

    observe({
      i <- (input$swap %% 2) + 1

      s <-
        if (non_null(isolate(input$check))) {
          names(which(isolate(input$check)))
        }

      update_checkbox(
        id = "check",
        choices = c("Left", "Right"),
        select = s,
        layout = LAYOUTS[i]
      )
    })

    observe({
      print(input$check)
    })
  }
)

shiny::shinyApp(
  ui = fluidPage(
    checkboxInput("id", "Label")
  ),
  server = function(input, output) {}
)

# form input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    bslib::layout_columns(
      input_form(
        id = "testForm",
        label = "Test form",
        input_button(
          id = "counter",
          label = "Counter"
        ),
        input_checkbox(
          id = "locations",
          choices = c("Home", "Work", "Other")
        ),
        form_submit_button(
          label = "Submit"
        )
      ),
      input_button(
        id = "alt",
        label = "Alternate submission"
      )
    )
  ),
  server = function(input, output) {
    observe({
      req(input$alt > 0)

      submit_form("testForm", "Submit")
    })

    observe({
      print(input$testForm)
    })

    observe({
      print(input$locations)
    })

    observe({
      print(input$counter)
    })
  }
)


# link input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    bslib::card(
      p(
        "Give it a try",
        input_link(
          id = "go",
          label = "Go!",
          stretch = TRUE,
          icon = bsicons::bs_icon("globe")
        )
      )
    )
  ),
  server = function(input, output) {
    observe({
      print(input$go)
    })
  }
)

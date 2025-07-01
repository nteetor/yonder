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

# checkbox  input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_checkbox(
      id = "include",
      choice = "Include"
    )
  ),
  server = function(input, output) {
    observe({
      print(input$include)
    })
  }
)


# checkbox group input ----

shiny::shinyApp(
  ui = local({
    choices <- c("Hello", "Howdy", "Hey there")

    bslib::page_fluid(
      bslib::layout_columns(
        bslib::card(
          bslib::card_body(
            input_checkbox_group(
              id = "default1",
              choices = choices
            )
          ),
          bslib::card_body(
            input_checkbox_group(
              id = "default2",
              choices = choices,
              label = "before"
            )
          )
        ),
        bslib::card(
          input_checkbox_group(
            id = "buttons",
            choices = choices,
            appearance = "buttons"
          )
        ),
        bslib::card(
          bslib::card_body(
            input_checkbox_group(
              id = "switches1",
              choices = choices,
              appearance = "switches"
            )
          ),
          bslib::card_body(
            input_checkbox_group(
              id = "switches2",
              choices = choices,
              appearance = "switches",
              label = "before"
            )
          )
        ),
        bslib::card(
          bslib::card_body(
            input_checkbox_group(
              id = "list1",
              choices = choices,
              appearance = "list"
            )
          ),
          bslib::card_body(
            input_checkbox_group(
              id = "list2",
              choices = choices,
              appearance = "list",
              label = "before"
            )
          )
        )
      )
    )
  }),
  server = function(input, output) {}
)

shiny::shinyApp(
  ui = fluidPage(
    checkboxInput("id", "Label")
  ),
  server = function(input, output) {}
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

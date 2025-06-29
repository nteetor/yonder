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
    input_form(
      id = "testForm",
      label = "Test form",
      input_checkbox(
        id = "locations",
        choices = c("Home", "Work", "Other")
      ),
      form_submit_button(
        label = "Submit"
      )
    )
  ),
  server = function(input, output) {
    observe({
      print(input$locations)
    })
  }
)


# input link ----
shiny::shinyApp(
  ui = bslib::page_fluid(
    bslib::card(
      p(
        "Hello",
        input_link(
          id = "link",
          label = "world",
          stretch = TRUE,
          icon = bsicons::bs_icon("globe")
        )
      )
    ),
    input_button(
      id = "button",
      label = "Button"
    )
  ),
  server = function(input, output) {
    observe({
      print(input$link)
    })

    observe({
      print(input$button)
    })

    # observe({
    #   update_button(
    #     id = "bsidesButton",
    #     value = input$shinyButton
    #   )
    # })
  }
)

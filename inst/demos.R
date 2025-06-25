# input chip ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_chip(
      id = "testchip",
      choices = c("Choice 1", "Choice 2 ")
    )
  ),
  server = function(input, output) {}
)

# input checkbox button ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_checkbutton(
      id = "checkbutton",
      choices = c("Choice 1", "Choice 2")
    )
  ),
  server = function(input, output) {
    observe({
      print(input$checkbutton)
    })
  }
)


# input checkbox ----

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

      update_checkbox(
        id = "check",
        choices = c("Left", "Right"),
        select = isolate(names(which(input$check))),
        layout = LAYOUTS[i]
      )
    })
  }
)

shiny::shinyApp(
  ui = fluidPage(
    checkboxInput("id", "Label")
  ),
  server = function(input, output) {}
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

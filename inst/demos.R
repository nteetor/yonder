# button input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_button(
      id = "count",
      text = "Count"
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

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_checkbox(
      id = "include",
      choice = "Include",
      disable = TRUE
    ),
    shiny::textInput(
      inputId = "feature",
      label = NULL
    )
  ),
  server = function(input, output) {
    observeEvent(input$feature, {
      update_checkbox(
        id = "include",
        choice = paste("Include", input$feature),
        value = TRUE
      )
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
            id = "buttons1",
            choices = choices,
            appearance = "buttons"
          ),
          input_checkbox_group(
            id = "button2",
            choices = choices,
            appearance = "buttons",
            layout = "row"
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

# dropdown input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_menu(
      id = "choices",
      label = "Choices",
      choices = paste("Choice", 1:5)
    )
  ),
  server = function(input, output) {
    observe({
      print(input$choices)
    })
  }
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

# list group input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_list_group(
      id = "items",
      choices = paste("Item", 1:5),
      layout = "row"
    )
  ),
  server = function(input, output) {
    observe({
      print(input$items)
    })
  }
)

# menu input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_menu(
      id = "print",
      label = "Print",
      choices = c(
        "Print all",
        "Print header",
        "Print first page"
      )
    )
  ),
  server = function(input, output) {
    observe({
      print(input$print)
    })
  }
)

# radio group input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    bslib::layout_columns(
      bslib::card(
        input_radio_group(
          id = "default1",
          choices = c("Veggie", "Meat", "Other")
        ),
        input_radio_group(
          id = "default2",
          choices = c("Veggie", "Meat", "Other"),
          layout = "row"
        ),
        input_radio_group(
          id = "default3",
          choices = c("Veggie", "Meat", "Other"),
          label = "before"
        )
      ),
      bslib::card(
        input_radio_group(
          id = "buttons1",
          choices = c("Veggie", "Meat", "Other"),
          appearance = "buttons"
        ),
        input_radio_group(
          id = "buttons2",
          choices = c("Veggie", "Meat", "Other"),
          appearance = "buttons",
          layout = "row"
        )
      ),
      bslib::card(
        input_radio_group(
          id = "switches1",
          choices = c("Veggie", "Meat", "Other"),
          appearance = "switches"
        ),
        input_radio_group(
          id = "switches2",
          choices = c("Veggie", "Meat", "Other"),
          appearance = "switches",
          layout = "row"
        ),
        input_radio_group(
          id = "switches3",
          choices = c("Veggie", "Meat", "Other"),
          appearance = "switches",
          label = "before"
        )
      ),
      bslib::card(
        input_radio_group(
          id = "list1",
          choices = c("Veggie", "Meat", "Other"),
          appearance = "list"
        ),
        input_radio_group(
          id = "list2",
          choices = c("Veggie", "Meat", "Other"),
          appearance = "list",
          label = "before"
        )
      )
    )
  ),
  server = function(input, output, session) {
    observe({
      print(input$radio1)
    })
  }
)

# range input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_range(
      id = "volume"
    )
  ),
  server = function(input, output) {
    observe({
      print(input$volume)
    })
  }
)

# select input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_select(
      id = "choices",
      choices = paste("Choice", 1:5)
    ),
    input_checkbox(
      id = "disable",
      choice = "Disable"
    )
  ),
  server = function(input, output) {
    observe({
      print(input$choices)
    })

    observeEvent(input$disable, {
      print("disable")

      update_select(
        id = "choices",
        disable = if (isTRUE(input$disable)) {
          paste("Choice", c(1, 3, 5))
        } else {
          FALSE
        }
      )
    })
  }
)

# text input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_text(
      id = "name",
      placeholder = "Name"
    ),
    shiny::textInput(
      inputId = "name2",
      label = NULL,
      placeholder = "Shiny name"
    )
  ),
  server = function(input, output) {
    observe({
      print(input$name)
    })

    observe({
      print(input$name2)
    })
  }
)

# text group input ----

shiny::shinyApp(
  ui = bslib::page_fluid(
    input_text_group(
      id = "cents1"
    ),
    input_text_group(
      id = "cents2",
      left = "$"
    ),
    input_text_group(
      id = "cents3",
      left = c("$", "0.")
    ),
    input_text_group(
      id = "cents4",
      left = c("user", "@"),
      right = ".com"
    )
  ),
  server = function(input, output) {
    observe({
      print(input$cents1)
    })

    observe({
      freezeReactiveValue(input, "cents2")
      update_text_group(
        id = "cents2",
        value = "420",
        disable = TRUE
      )
    })

    observe({
      print(input$cents2)
    })

    observe({
      print(input$cents3)
    })

    observe({
      print(input$cents4)
    })
  }
)

# modal ----

library(shiny)
library(bslib)

shinyApp(
  page_fluid(
    input_button("click", "Click")
  ),
  function(input, output, session) {
    observeEvent(input$click, {
      modal_show(modal_dialog(
        id = "test",
        "Hello, world"
      ))
    })

    observeEvent(input$test, {
      print(input$test)
    })
  }
)

shinyApp(
  page_fluid(
    input_button("show1", "Show Modal 1"),
    input_button("show2", "Show Modal 2"),
    modal_dialog(
      id = "modal1",
      modal_header(modal_title("Modal 1")),
      "You clicked button 1"
    ),
    modal_dialog(
      id = "modal2",
      position = "center",
      backdrop = "none",
      scroll = "body",
      modal_header(modal_title("Modal 2")),
      "You clicked button 2",
      !!!replicate(40, br(), FALSE),
      "Surprise!"
    )
  ),
  function(input, output) {
    observeEvent(input$show1, {
      modal_show("modal1")
    })

    observeEvent(input$show2, {
      modal_show("modal2")
    })
  }
)

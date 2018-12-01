context("selectInput()")

# test_example("../../man/selectInput.Rd")

test_that("update", {
  skip("interactive")

  shinyApp(
    ui = container(
      selectInput(
        id = "test",
        choices = c("One", "Two", "Three"),
        values = 1:3
      ),
      buttonInput(
        id = "update",
        label = "Update choices"
      )
    ) %>%
      display("flex") %>%
      flex(justify = "around"),
    server = function(input, output) {
      observe({
        print(input$test)

        if (input$test == 1) {
          invalidateInput("test", "Select another value")
        } else {
          validateInput("test")
        }
      })

      observeEvent(input$update, {
        updateInput(
          id = "test",
          choices = c("Four", "Five", "Six")
        )
      })
    }
  )
})

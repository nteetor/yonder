---
this: dropdown
filename: R/dropdown.R
layout: page
roxygen:
  title: Dropdown menus
  description: |-
    Dropdown menus are a container for buttons, text, and form inputs. See
    argument `...` for details on composing dropdown menus.
  parameters:
  - name: label
    description: |-
      A character string specifying the label of the dropdown's
      button.
  - name: '...'
    description: |-
      Character strings or vectors, header tag elements, button inputs,
      or form inputs specifying the elements of the dropdown. These elements may
      be grouped into lists to create a menu with sections. `h6()` is the
      recommended heading level for menu headers. Character vectors are converted
      into paragraphs of text. To format menu text use `p()` and utility
      functions.  Named arguments are passed HTML attributes to the parent
      element.
  - name: direction
    description: |-
      One of `"up"`, `"right"`, `"down"`, or `"left"` specifying
      the direction in which the menu opens, defaults to `"down"`.
  - name: split
    description: |-
      One of `TRUE` or `FALSE` specifying if the dropdown toggle button
      is split into two distinct buttons, defaults to `FALSE`. This is a stylistic
      modification which properly spaces the dropdown toggle icon and aligns the
      dropdown menu to the toggle icon.
  sections: ~
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                dropdown(
                  label = "Dropdown",
                  split = TRUE,
                  formInput(
                    id = "login",
                    formGroup(
                      label = "Email address",
                      textInput(
                        id = "email",
                        placeholder = "email@example.com"
                      )
                    ),
                    formGroup(
                      label = "Password",
                      passwordInput(
                        id = "password",
                        placeholder = "*****"
                      )
                    ),
                    submit = submitInput(
                      label = "Sign in"
                    )
                  ) %>%
                    padding(3, 4, 3, 4),
                  list(
                    buttonInput(
                      id = "signup",
                      label = "New? Sign up"
                    ),
                    buttonInput(
                      id = "forgot",
                      label = "Forgot password?"
                    )
                  )
                )
              ),
              column(
                verbatimTextOutput("values")
              )
            )
          ),
          server = function(input, output) {
            output$values <- renderPrint(
              list(
                email = input$email,
                password = input$password,
                signup = input$signup,
                forgot = input$forgot
              )
            )
          }
        )
      }
    output: []
---

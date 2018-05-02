---
layout: page
slug: dropdown-input
roxygen:
  rdname: ~
  name: dropdownInput
  doctype: ~
  title: Dropdown input
  description: |-
    Dropdown inputs, or dropdown menus, a similar to form inputs. The dropdown
    input has no value per say, but acts as an intelligent container for button
    and form inputs.
  parameters:
  - name: id
    description: A character string specifying the id of the dropdown input.
  - name: label
    description: |-
      A character string specifying the label of the dropdown's
      button.
  - name: '...'
    description: |-
      Character strings or vectors, header tag elements, button inputs,
      or form inputs specifying the elements of the dropdown. These elements may
      be grouped into lists, in which case menu dividers are placed before,
      after, or between the lists of elements. `h6()` is the recommended heading
      level for menu headers. Character vectors are converted into paragraphs of
      text. To format menu text use `p()` and any utility functions instead.
      Named arguments are passed HTML attributes to the parent element.
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
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              dropdownInput(
                id = NULL,
                label = "Dropdown",
                split = TRUE,
                formInput(
                  id = NULL,
                  submit = NULL,
                  textInput(
                    id = "email",
                    placeholder = "email@example.com"
                  ),
                  textInput(
                    id = "password",
                    placeholder = "Password"
                  )
                ) %>%
                  padding(3),
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
            col(
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
  aliases: ~
  family: ~
  export: yes
  filename: dropdown.R
  source: "dropdownInput <- function(id, label, ..., direction = \"down\", \n    split
    = FALSE) {\n    if (!re(direction, \"up|right|down|left\", len0 = FALSE)) {\n
    \       stop(\"invalid `dropdownInput` arguments, `direction` must be one of \",
    \n            \"\\\"up\\\", \\\"right\\\", \\\"down\\\", or \\\"left\\\"\", call.
    = FALSE)\n    }\n    args <- dots_list(...)\n    items <- elements(args)\n    attrs
    <- attribs(args)\n    tags$div(class = collate(\"dull-dropdown-input\", \"btn-group\",
    \n        paste0(\"drop\", direction)), id = id, if (split) {\n        tags$button(class
    = \"btn btn-grey\", label)\n    }, tags$button(class = collate(\"btn\", \"btn-grey\",
    \"dropdown-toggle\", \n        if (split) \n            \"dropdown-toggle-split\"),
    type = \"button\", `data-toggle` = \"dropdown\", \n        `aria-haspop` = \"true\",
    `aria-expanded` = \"false\", if (!split) \n            label\n        else tags$span(class
    = \"sr-only\", \"Dropdown toggle\")), \n        tags$div(class = \"dropdown-menu\",
    Reduce(x = lapply(items, \n            dropdownItem), function(acc, obj) {\n            if
    (is_tag(acc)) {\n                acc <- list(acc)\n            }\n            if
    (is_strictly_list(acc[[length(acc)]]) || is_strictly_list(obj)) {\n                return(c(acc,
    list(tags$div(class = \"dropdown-divider\")), \n                  list(obj)))\n
    \           }\n            return(c(acc, list(obj)))\n        })), include(\"core\"))\n}"
---

---
name: formSubmit
title: Form inputs
description: |-
  Form inputs are a new reactive input. Form inputs are an alternative to
  shiny's submit buttons. A form input is comprised of any number of inputs.
  The value of these inputs will _not_ change until a form submit button within
  the form input is clicked. A form input's reactive value depends on the
  clicked form submit button. This allows you to distinguish between different
  form submission types, think "login" versus "register".

  A form submit button, `formSubmit()`, is a special type of button used to
  control form input submission. A form input and its child reactive inputs
  will _never_ update if a form submit button is not included in `...` passed
  to `formInput()`.
inheritParams: checkboxInput
parameters:
- name: '...'
  description: |-
    Any number of unnamed arguments passed as child elements to the
    parent form element or named arguments passed as HTML attributes to the
    parent element. At least one `formSubmit()` must be included.
- name: inline
  description: |-
    One of `TRUE` or `FALSE`, if `TRUE` the form and its child
    elements are rendered in a horizontal row, defaults to `FALSE`. On small
    viewports, think mobile device, `inline` intentionally has no effect and
    the form will span multiple lines.
details: |-
  When `inline` is `TRUE` you may want to adjust the right margin of each child
  element for viewports larger than mobile, `margin(<TAG>, right = c(sm = 2))`,
  see [margin()]. You only need to apply extra space for larger viewports
  because inline forms do not take effect on small viewports.
sections:
- title: Frozen inputs with scope
  body: |-
    ```R
    ui <- container(
      formInput(
        id = "login",
        formGroup(
          label = "Email",
          emailInput(
            id = "email"
          )
        ),
        formGroup(
          label = "Password",
          passwordInput(
            id = "password"
          )
        ),
        formSubmit(
          "Login", "go!"
        )
      )
    )

    server <- function(input, output) {
      # Will not react until the form submit button is
      # clicked.
      observe({
        print(input$email)
        print(input$password)
      })
    }

    shinyApp(ui, server)
    ```
family: inputs
export: ''
examples:
- title: A simple form
  body:
  - type: code
    content: |-
      card(
        header = "Please pick a flavor",
        formInput(
          id = "form1",
          formGroup(
            label = "Ice creams",
            radioInput(
              id = "flavor",
              choices = c("Mint", "Moose tracks", "Marble"),
            )
          ),
          formSubmit("Make choice", "choice") %>%
            background("teal")
        )
      ) %>%
        border("teal") %>%
        width(50)
    output: |-
      <div class="card border border-teal w-50">
        <div class="card-header">Please pick a flavor</div>
        <div class="card-body">
          <form class="yonder-form" id="form1">
            <div class="form-group">
              <label>Ice creams</label>
              <div class="yonder-radio" id="flavor">
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-737-229" name="flavor" value="Mint" checked autocomplete="off"/>
                  <label class="custom-control-label" for="radio-737-229">Mint</label>
                </div>
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-888-546" name="flavor" value="Moose tracks" autocomplete="off"/>
                  <label class="custom-control-label" for="radio-888-546">Moose tracks</label>
                </div>
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-306-368" name="flavor" value="Marble" autocomplete="off"/>
                  <label class="custom-control-label" for="radio-306-368">Marble</label>
                  <div class="valid-feedback"></div>
                  <div class="invalid-feedback"></div>
                </div>
              </div>
            </div>
            <button class="yonder-form-submit btn btn-teal" value="choice">Make choice</button>
          </form>
        </div>
      </div>
rdname: formSubmit
layout: doc
---

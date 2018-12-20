---
name: formInput
title: Form inputs
description: |-
  Form inputs are a new reactive input. Form inputs are an alternative to
  shiny's submit buttons. A form input is comprised of any number of
  inputs. The value of these inputs will not change until the form input's
  submit input is clicked. A form input's reactive value also depends on the
  submit input. This allows you to distinguish between different clicks if
  your form includes multiple submit inputs.

  **Important** if `id` or `submit` are `NULL` the form input will not freeze
  its child inputs. This can be useful if you want to use a `formInput()`
  solely for page layout.
templateVar:
  name: '...'
  description: Any number of unnamed arguments (inputs or tag elements) passed as
    child elements of the form.
parameters:
- name: submit
  description: |-
    A submit button or tags containing a submit button. The submit
    button will trigger the update of input form elements. Defaults to
    [submitInput()].
- name: inline
  description: |-
    One of `TRUE` or `FALSE`, if `TRUE` the form and its child
    elements are rendered in a horizontal row, defaults to `FALSE`. On small
    viewports, think mobile device, `inline` has no effect and the form will
    span multiple lines.
- name: id
  description: A character string specifying the reactive id of the input.
- name: '...'
  description: |-
    Any number of unnamed arguments (inputs or tag elements) passed as child elements of the form.

    Additional named arguments passed as HTML attributes to the parent element.
details: |-
  When `inline` is `TRUE` you may want to adjust the right margin of each child
  element for viewports larger than mobile, `margin(<TAG>, right = c(sm = 2))`,
  more information at [margin()]. You only need to apply extra space for larger
  viewports because inline forms do not take effect on small viewports.
sections:
- title: Frozen inputs with scope
  body: |-
    ```R
    ui <- container(
      formInput(
        id = "form",
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
        )
      )
    )

    server <- function(input, output) { }

    shinyApp(ui, server)
    ```
family: inputs
export: ''
examples:
- title: '## Customizing the submit button'
  body:
  - code: |-
      card(
        header = "Please pick a flavor",
        formInput(
          id = NULL,
          formGroup(
            label = "Ice creams",
            radioInput(
              id = "flavorChoice",
              choices = c("Mint", "Moose tracks", "Marble"),
            )
          ),
          submit = submitInput(  # <-
            label = "Make choice",
            block = TRUE
          ) %>%
            background("teal")
        )
      ) %>%
        border("teal") %>%
        width(50)
    output: |-
      <div class="card border border-teal w-50">
        <div class="card-header">Please pick a flavor</div>
        <div class="card-body">
          <form class="yonder-form">
            <div class="form-group">
              <label>Ice creams</label>
              <div class="yonder-radio" id="flavorChoice">
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-132-215" name="flavorChoice" value="Mint" checked/>
                  <label class="custom-control-label" for="radio-132-215">Mint</label>
                </div>
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-942-322" name="flavorChoice" value="Moose tracks"/>
                  <label class="custom-control-label" for="radio-942-322">Moose tracks</label>
                </div>
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-331-417" name="flavorChoice" value="Marble"/>
                  <label class="custom-control-label" for="radio-331-417">Marble</label>
                </div>
                <div class="invalid-feedback"></div>
              </div>
            </div>
            <button class="yonder-submit btn btn-block btn-teal" role="button" value="Make choice">Make choice</button>
          </form>
        </div>
      </div>
layout: doc
---

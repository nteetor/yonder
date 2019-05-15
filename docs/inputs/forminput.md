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

  A submit input is a special type of button used to control form input
  submission. Because of their specific usage, submit inputs do not require an
  `id`, but may have a specified `value`. Submit inputs will _not_ freeze all
  reactive inputs, see [formInput()].

  If `id` or `submit` are `NULL` the form input will not freeze its child
  inputs.
inheritParams: checkboxInput
parameters:
- name: '...'
  description: |-
    Any number of unnamed arguments (inputs or tag elements) passed as
      child elements to the form.

      Additional named arguments passed as HTML attributes to the parent element.
- name: submit
  description: |-
    A button input, when clicked the form input will update its
    reactive child inputs, defaults to `buttonInput(NULL, "Submit")`.
- name: inline
  description: |-
    One of `TRUE` or `FALSE`, if `TRUE` the form and its child
    elements are rendered in a horizontal row, defaults to `FALSE`. On small
    viewports, think mobile device, `inline` intentionally has no effect and
    the form will span multiple lines.
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
              id = "flavorChoice",
              choices = c("Mint", "Moose tracks", "Marble"),
            )
          ),
          submit = buttonInput(  # <-
            id = "submi1",
            label = "Make choice"
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
          <form class="yonder-form" id="form1">
            <div class="form-group">
              <label>Ice creams</label>
              <div class="yonder-radio" id="flavorChoice">
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-71-160" name="flavorChoice" value="Mint" checked autocomplete="off"/>
                  <label class="custom-control-label" for="radio-71-160">Mint</label>
                </div>
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-859-936" name="flavorChoice" value="Moose tracks" autocomplete="off"/>
                  <label class="custom-control-label" for="radio-859-936">Moose tracks</label>
                </div>
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-540-180" name="flavorChoice" value="Marble" autocomplete="off"/>
                  <label class="custom-control-label" for="radio-540-180">Marble</label>
                  <div class="valid-feedback"></div>
                  <div class="invalid-feedback"></div>
                </div>
              </div>
            </div>
            <button class="yonder-button btn btn-teal yonder-form-submit" type="button" role="button" id="submi1" autocomplete="off">Make choice</button>
          </form>
        </div>
      </div>
rdname: formInput
layout: doc
---

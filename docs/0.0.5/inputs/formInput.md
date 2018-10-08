---
this: formInput
filename: R/forms.R
layout: page
roxygen:
  title: Form inputs
  description: |-
    Form inputs are a new reactive input. Form inputs are an alternative to
    shiny's submit buttons. A form input is comprised of any number of
    inputs. The value of these inputs will not change until the form input's
    submit button is clicked. A form input has no value.

    **Important** if `id` or `submit` are `NULL` the form input will not freeze
    its child inputs. This can be useful if you want to use a `formInput()`
    solely for page layout.
  parameters:
  - name: id
    description: A character string specifying an id for the form input.
  - name: '...'
    description: |-
      Any number of inputs, tags, or additional named arguments passed
      as HTML attributes to the parent element.
  - name: submit
    description: |-
      A submit button or tags containing a submit button. The submit
      button will trigger the update of input form elements. Defaults to
      [submitInput()](/yonder/0.0.5/submitInput.html).
  - name: inline
    description: |-
      One of `TRUE` or `FALSE`, if `TRUE` the form and its child
      elements are rendered in a horizontal row, defaults to `FALSE`. On small
      viewports, think mobile device, `inline` has no effect and the form will
      span multiple lines.
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
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Customizing the submit button</h3>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <div class="card border-teal border w-50">
        <div class="card-header">Please pick a flavor</div>
        <div class="card-body">
          <form class="yonder-form">
            <div class="form-group">
              <label>Ice creams</label>
              <div class="yonder-radio" id="flavorChoice">
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-524-656" name="flavorChoice" data-value="Mint" checked/>
                  <label class="custom-control-label" for="radio-524-656">Mint</label>
                </div>
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-906-415" name="flavorChoice" data-value="Moose tracks"/>
                  <label class="custom-control-label" for="radio-906-415">Moose tracks</label>
                </div>
                <div class="custom-control custom-radio">
                  <input class="custom-control-input" type="radio" id="radio-458-306" name="flavorChoice" data-value="Marble"/>
                  <label class="custom-control-label" for="radio-458-306">Marble</label>
                </div>
                <div class="invalid-feedback"></div>
              </div>
            </div>
            <button class="yonder-submit btn btn-block btn-teal" data-type="submit" role="button">Make choice</button>
          </form>
        </div>
      </div>
---

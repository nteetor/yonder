---
this: dropdown
filename: R/dropdown.R
layout: page
include: ~
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
      functions. Named arguments are passed as HTML attributes to the parent
      element.
  - name: direction
    description: |-
      One of `"up"`, `"right"`, `"down"`, or `"left"` specifying
      the direction in which the menu opens, defaults to `"down"`.
  sections: []
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Simple options w/ buttons</h3>
  - type: source
    value: |2-

      dropdown(
        label = "Choices",
        buttonInput("choice1", "Choice 1"),
        buttonInput("choice2", "Choice 2"),
        buttonInput("choice3", "Choice 3")
      )
  - type: output
    value: |-
      <div class="dropdown">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">Choices</button>
        <div class="dropdown-menu">
          <button class="yonder-button dropdown-item" type="button" role="button" id="choice1">Choice 1</button>
          <button class="yonder-button dropdown-item" type="button" role="button" id="choice2">Choice 2</button>
          <button class="yonder-button dropdown-item" type="button" role="button" id="choice3">Choice 3</button>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Grouped sections</h3>
  - type: source
    value: |2-

      dropdown(
        label = "Sections",
        list(
          h6("Section 1"),
          buttonInput("addA", "Add A"),
          buttonInput("addB", "Add B")
        ),
        list(
          h6("Section 2"),
          buttonInput("calcC", "Calculate C"),
          buttonInput("calcD", "Calculate D")
        )
      )
  - type: output
    value: |-
      <div class="dropdown">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">Sections</button>
        <div class="dropdown-menu">
          <h6 class="dropdown-header">Section 1</h6>
          <button class="yonder-button dropdown-item" type="button" role="button" id="addA">Add A</button>
          <button class="yonder-button dropdown-item" type="button" role="button" id="addB">Add B</button>
          <div class="dropdown-divider"></div>
          <h6 class="dropdown-header">Section 2</h6>
          <button class="yonder-button dropdown-item" type="button" role="button" id="calcC">Calculate C</button>
          <button class="yonder-button dropdown-item" type="button" role="button" id="calcD">Calculate D</button>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Direction variations</h3>
  - type: source
    value: |2-

      div(
        lapply(
          c("up", "down", "left", "right"),
          function(d) {
            dropdown(
              label = d,
              direction = d,
              buttonInput(NULL, "Nam euismod"),
              buttonInput(NULL, "Nunc eleifend"),
              buttonInput(NULL, "Nullam eu")
            ) %>%
              margin(3)
          }
        )
      ) %>%
        display("flex")
  - type: output
    value: |-
      <div class="d-flex">
        <div class="dropdown dropup m-3">
          <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">up</button>
          <div class="dropdown-menu">
            <button class="yonder-button dropdown-item" type="button" role="button">Nam euismod</button>
            <button class="yonder-button dropdown-item" type="button" role="button">Nunc eleifend</button>
            <button class="yonder-button dropdown-item" type="button" role="button">Nullam eu</button>
          </div>
        </div>
        <div class="dropdown m-3">
          <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">down</button>
          <div class="dropdown-menu">
            <button class="yonder-button dropdown-item" type="button" role="button">Nam euismod</button>
            <button class="yonder-button dropdown-item" type="button" role="button">Nunc eleifend</button>
            <button class="yonder-button dropdown-item" type="button" role="button">Nullam eu</button>
          </div>
        </div>
        <div class="dropdown dropleft m-3">
          <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">left</button>
          <div class="dropdown-menu">
            <button class="yonder-button dropdown-item" type="button" role="button">Nam euismod</button>
            <button class="yonder-button dropdown-item" type="button" role="button">Nunc eleifend</button>
            <button class="yonder-button dropdown-item" type="button" role="button">Nullam eu</button>
          </div>
        </div>
        <div class="dropdown dropright m-3">
          <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">right</button>
          <div class="dropdown-menu">
            <button class="yonder-button dropdown-item" type="button" role="button">Nam euismod</button>
            <button class="yonder-button dropdown-item" type="button" role="button">Nunc eleifend</button>
            <button class="yonder-button dropdown-item" type="button" role="button">Nullam eu</button>
          </div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Include forms</h3>
  - type: source
    value: |2-

      dropdown(
        label = "Sign in",
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
          padding(3, 4, 3, 4)
      )
  - type: output
    value: |-
      <div class="dropdown">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">Sign in</button>
        <div class="dropdown-menu">
          <form class="yonder-form pt-3 pr-4 pb-3 pl-4" id="login">
            <div class="form-group">
              <label>Email address</label>
              <div class="yonder-textual" id="email">
                <input class="form-control" type="text" placeholder="email@example.com"/>
                <div class="invalid-feedback"></div>
              </div>
            </div>
            <div class="form-group">
              <label>Password</label>
              <div class="yonder-textual" id="password">
                <input class="form-control" type="password" placeholder="*****"/>
                <div class="invalid-feedback"></div>
              </div>
            </div>
            <button class="yonder-submit btn btn-blue" data-type="submit" role="button">Sign in</button>
          </form>
        </div>
      </div>
---

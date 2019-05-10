---
name: dropdown
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
      functions.

      Additional named arguments are passed as HTML attributes to the parent
      element.
- name: direction
  description: |-
    One of `"up"`, `"right"`, `"down"`, or `"left"` specifying
    the direction in which the menu opens, defaults to `"down"`.
- name: align
  description: |-
    One of `"left"` or `"right"` specifying which side of the button
    to align the dropdown menu to, defaults to `"left"`.
family: content
export: ''
examples:
- title: Dropdown with buttons
  body:
  - type: code
    content: |-
      dropdown(
        label = "Choices",
        buttonInput("choice1", "Choice 1"),
        buttonInput("choice2", "Choice 2"),
        buttonInput("choice3", "Choice 3")
      )
    output: |-
      <div class="dropdown">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">Choices</button>
        <div class="dropdown-menu">
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="choice1" autocomplete="off">Choice 1</button>
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="choice2" autocomplete="off">Choice 2</button>
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="choice3" autocomplete="off">Choice 3</button>
        </div>
      </div>
- title: Dropdown with links
  body:
  - type: code
    content: |-
      dropdown(
        label = "Choices",
        linkInput("link1", "Choice 1"),
        linkInput("link2", "Choice 2")
      )
    output: |-
      <div class="dropdown">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">Choices</button>
        <div class="dropdown-menu">
          <button class="yonder-link btn btn-link dropdown-item" id="link1">Choice 1</button>
          <button class="yonder-link btn btn-link dropdown-item" id="link2">Choice 2</button>
        </div>
      </div>
- title: Grouped sections
  body:
  - type: code
    content: |-
      dropdown(
        label = "Sections",
        h6("Section 1"),
        buttonInput("a", "Option A"),
        buttonInput("b", "Option B"),
        hr(),
        h6("Section 2"),
        buttonInput("c", "Option C"),
        buttonInput("d", "Option D")
      )
    output: |-
      <div class="dropdown">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">Sections</button>
        <div class="dropdown-menu">
          <h6 class="dropdown-header">Section 1</h6>
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="a" autocomplete="off">Option A</button>
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="b" autocomplete="off">Option B</button>
          <div class="dropdown-divider"></div>
          <h6 class="dropdown-header">Section 2</h6>
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="c" autocomplete="off">Option C</button>
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="d" autocomplete="off">Option D</button>
        </div>
      </div>
- title: Direction variations
  body:
  - type: code
    content: |-
      dropdown(
        label = "Up!",
        direction = "up",
        buttonInput("up1", "Choice 1"),
        buttonInput("up2", "Choice 2")
      )
    output: |-
      <div class="dropdown dropup">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">Up!</button>
        <div class="dropdown-menu">
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="up1" autocomplete="off">Choice 1</button>
          <button class="yonder-button btn btn-grey dropdown-item" type="button" role="button" id="up2" autocomplete="off">Choice 2</button>
        </div>
      </div>
- title: Dropdowns with forms
  body:
  - type: code
    content: |-
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
          submit = buttonInput("signin", "Sign in")
        ) %>%
          padding(3, 4, 3, 4)
      )
    output: |-
      <div class="dropdown">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">Sign in</button>
        <div class="dropdown-menu">
          <form class="yonder-form p-3 pt-4 pr-3 pb-4" id="login">
            <div class="form-group">
              <label>Email address</label>
              <div class="yonder-textual" id="email">
                <input class="form-control" type="text" placeholder="email@example.com" autocomplete="off"/>
                <div class="valid-feedback"></div>
                <div class="invalid-feedback"></div>
              </div>
            </div>
            <div class="form-group">
              <label>Password</label>
              <div class="yonder-textual" id="password">
                <input class="form-control" type="password" placeholder="*****" autocomplete="off"/>
                <div class="valid-feedback"></div>
                <div class="invalid-feedback"></div>
              </div>
            </div>
            <button class="yonder-button btn btn-grey yonder-form-submit" type="button" role="button" id="signin" autocomplete="off">Sign in</button>
          </form>
        </div>
      </div>
rdname: dropdown
sections: []
layout: doc
---

---
name: formGroup
title: Add labels, help text, and formatting to inputs
description: |-
  Form groups are a way of labelling an input. Form rows are similar to
  [columns()]s, but include additional styles intended for forms. The
  flexibility provided by form rows and groups means you can confidently
  develop shiny applications for devices and screens of varying sizes.
parameters:
- name: label
  description: |-
    A character string specifying a label for the input or `NULL`
    in which case a label is not added.
- name: input
  description: A tag element specifying the input to label.
- name: help
  description: |-
    A character string specifying help text for the input, defaults
    to `NULL`, in which case help text is not added.
- name: '...'
  description: |-
    For **formGroup**, additional named arguments passed as HTML
      attributes to the parent element.

      For **formRow**, any number of `formGroup`s or additional named arguments
      passed as HTML attributes to the parent element.
- name: width
  description: |-
    A [responsive](responsive.html) argument. One of `1:12` or "auto" specifying a
    column width for the form group, defaults to `NULL`.
family: layout
export: ''
examples:
- title: Grid layout forms
  body:
  - type: text
    content: Use responsive arguments to adjust form layouts based on viewport size.
      Be sure to adjust the size of your browser window between large and small.
    output: ~
  - type: code
    content: |-
      card(
        formRow(
          formGroup(
            width = c(md = 6),  # <-
            label = "Email",
            emailInput(
              id = "email",
              placeholder = "e@mail.com"
            )
          ),
          formGroup(
            width = c(md = 6),  # <-
            label = "Password",
            passwordInput(
              id = "password",
              placeholder = "123456"
            ),
            help = "Please consider something better than 123456"
          )
        ),
        formGroup(
          label = "Username",
          groupInput(
            id = "username",
            left = "@"
          )
        ),
        buttonInput(
          id = "go",
          label = "Go!"
        ) %>%
          background("blue")
      ) %>%
        margin(3) %>%
        background("grey")
    output: |-
      <div class="card m-3 bg-grey">
        <div class="card-body">
          <div class="form-row">
            <div class="form-group col-md-6">
              <label>Email</label>
              <div class="yonder-textual" id="email">
                <input class="form-control" type="email" placeholder="e@mail.com" autocomplete="off"/>
                <div class="invalid-feedback"></div>
              </div>
            </div>
            <div class="form-group col-md-6">
              <label>Password</label>
              <div class="yonder-textual" id="password">
                <input class="form-control" type="password" placeholder="123456" autocomplete="off"/>
                <div class="invalid-feedback"></div>
              </div>
              <small class="form-text text-muted">Please consider something better than 123456</small>
            </div>
          </div>
          <div class="form-group">
            <label>Username</label>
            <div class="yonder-group input-group" id="username">
              <div class="input-group-prepend">
                <span class="input-group-text">@</span>
              </div>
              <input type="text" class="form-control" autocomplete="off"/>
            </div>
          </div>
          <button class="yonder-button btn btn-blue" type="button" role="button" id="go" autocomplete="off">Go!</button>
        </div>
      </div>
rdname: formGroup
sections: []
layout: doc
---

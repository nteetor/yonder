---
name: margin
title: Tag element margin and padding
description: |-
  Use the `margin()` and `padding()` utilities to change the margin or padding
  of a tag element.  The margin of a tag element is the space outside and
  around the tag element, its border, and its content.  The padding of a tag
  element is the space between the tag element's border and its content or
  child elements. All arguments default to `NULL`, in which case they are
  ignored.
parameters:
- name: .tag
  description: A tag element.
- name: all
  description: |-
    A [responsive](responsive.html) argument. One of `0:5` or `"auto"` specifying
    a margin or padding for all sides of the tag element. 0 removes all
    space and 5 adds the most space.
- name: top,right,bottom,left
  description: |-
    A [responsive](responsive.html) argument. One of `0:5` or
    `"auto"`. 0 removes all space and 5 adds the most space.
family: design
export: ''
examples:
- title: Centering an element
  body:
  - type: text
    content: In most modern browsers you want to horizontally center a tag element
      using the flex layout. Alternatively, you can horizontally center an element
      using `margin(.., right = "auto", left = "auto")`.
    output: ~
  - type: code
    content: |-
      div(
        "Nam a sapien. Integer placerat tristique nisl.",
        style = "height: 100px; width: 200px;"
      ) %>%
        margin(top = 2, r = "auto", b = 2, l = "auto") %>%  # <-
        padding(3) %>%
        background("indigo")
    output: '<div style="height: 100px; width: 200px;" class="mt-2 mr-auto mb-2 ml-auto
      p-3 bg-indigo">Nam a sapien. Integer placerat tristique nisl.</div>'
- title: Building an inline form
  body:
  - type: text
    content: Inline form elements automatically use the flex layout providing you
      a means of creating condensed sets of inputs. However, you may need to adjust
      the spacing of the form's child elements.
    output: ~
  - type: text
    content: Here is an inline form without any additional spacing applied.
    output: ~
  - type: code
    content: |-
      formInput(
        id = "login",
        inline = TRUE,
        textInput(
          id = "name",
          placeholder = "full name"
        ),
        groupInput(
          id = "username",
          left = "@",
          placeholder = "username"
        ),
        checkboxInput(
          id = "remember",
          choice = "Remember me"
        )
      )
    output: |-
      <form class="yonder-form form-inline" id="login">
        <div class="yonder-textual" id="name">
          <input class="form-control" type="text" placeholder="full name"/>
          <div class="invalid-feedback"></div>
        </div>
        <div class="yonder-group input-group" id="username">
          <div class="input-group-prepend">
            <span class="input-group-text">@</span>
          </div>
          <input type="text" class="form-control" placeholder="username"/>
        </div>
        <div class="yonder-checkbox" id="remember">
          <div class="custom-control custom-checkbox">
            <input class="custom-control-input" type="checkbox" id="checkbox-742-987" name="remember" value="Remember me"/>
            <label class="custom-control-label" for="checkbox-742-987">Remember me</label>
            <div class="invalid-feedback"></div>
          </div>
        </div>
        <button class="yonder-submit btn btn-blue" role="button" value="Submit">Submit</button>
      </form>
  - type: text
    content: Without any adjustments the layout is not great. But, with some styling
      we can make this form sparkle. Notice we are also adjusting the default submit
      button added to the form input.
    output: ~
  - type: code
    content: |-
      formInput(
        id = "login2",
        inline = TRUE,
        textInput(
          id = "name",
          placeholder = "full name"
        ) %>%
          margin(r = c(sm = 2), b = 2),  # <-
        groupInput(
          id = "username",
          left = "@",
          placeholder = "username"
        ) %>%
          margin(r = c(sm = 2), b = 2),  # <-
        checkboxInput(
          id = "remember",
          choice = "Remember me"
        ) %>%
          margin(r = c(sm = 2), b = 2),  # <-
        submit = submitInput("Log in") %>%
          margin(b = 2)  # <-
      )
    output: |-
      <form class="yonder-form form-inline" id="login2">
        <div class="yonder-textual mr-sm-2 mb-2" id="name">
          <input class="form-control" type="text" placeholder="full name"/>
          <div class="invalid-feedback"></div>
        </div>
        <div class="yonder-group input-group mr-sm-2 mb-2" id="username">
          <div class="input-group-prepend">
            <span class="input-group-text">@</span>
          </div>
          <input type="text" class="form-control" placeholder="username"/>
        </div>
        <div class="yonder-checkbox mr-sm-2 mb-2" id="remember">
          <div class="custom-control custom-checkbox">
            <input class="custom-control-input" type="checkbox" id="checkbox-179-909" name="remember" value="Remember me"/>
            <label class="custom-control-label" for="checkbox-179-909">Remember me</label>
            <div class="invalid-feedback"></div>
          </div>
        </div>
        <button class="yonder-submit btn btn-blue mb-2" role="button" value="Log in">Log in</button>
      </form>
rdname: margin
sections: []
layout: doc
---

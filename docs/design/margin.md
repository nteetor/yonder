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
- name: tag
  description: A tag element.
- name: all,top,right,bottom,left
  description: |-
    A [responsive](layout/responsive.html) argument.

    For **padding()**, one of `0:5` or `"auto"` specifying padding for one or
    more sides of the tag element. 0 removes all inner space and 5 adds the
    most space.

    For **margin()**, one of `-5:5` or `"auto"` specifying a margin for one or
    more sides of the tag element. 0 removes all outer space, 5 adds the
    most space, and negative values will consume space pulling the element in
    that direction.
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
        groupTextInput(
          id = "username",
          left = "@",
          placeholder = "username"
        ),
        checkboxInput(
          id = "remember",
          choice = "Remember me"
        ),
        submit = buttonInput("go", "Login")
      )
    output: |-
      <form class="yonder-form form-inline" id="login">
        <div class="yonder-textual" id="name">
          <input class="form-control" type="text" placeholder="full name" autocomplete="off"/>
          <div class="valid-feedback"></div>
          <div class="invalid-feedback"></div>
        </div>
        <div class="yonder-group-text input-group" id="username">
          <div class="input-group-prepend">
            <span class="input-group-text">@</span>
          </div>
          <input type="text" class="form-control" placeholder="username" autocomplete="off"/>
          <div class="valid-feedback"></div>
          <div class="invalid-feedback"></div>
        </div>
        <div class="yonder-checkbox" id="remember">
          <div class="custom-control custom-checkbox">
            <input class="custom-control-input" type="checkbox" id="checkbox-44-44" name="checkbox-44-44" value="Remember me" autocomplete="off"/>
            <label class="custom-control-label" for="checkbox-44-44">Remember me</label>
            <div class="valid-feedback"></div>
            <div class="invalid-feedback"></div>
          </div>
        </div>
        <button class="yonder-button btn btn-grey yonder-form-submit" type="button" role="button" id="go" autocomplete="off">Login</button>
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
        groupTextInput(
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
        submit = buttonInput(NULL, "Log in") %>%
          margin(b = 2)  # <-
      )
    output: |-
      <form class="yonder-form form-inline" id="login2">
        <div class="yonder-textual mr-sm-2 mb-2" id="name">
          <input class="form-control" type="text" placeholder="full name" autocomplete="off"/>
          <div class="valid-feedback"></div>
          <div class="invalid-feedback"></div>
        </div>
        <div class="yonder-group-text input-group mr-sm-2 mb-2" id="username">
          <div class="input-group-prepend">
            <span class="input-group-text">@</span>
          </div>
          <input type="text" class="form-control" placeholder="username" autocomplete="off"/>
          <div class="valid-feedback"></div>
          <div class="invalid-feedback"></div>
        </div>
        <div class="yonder-checkbox mr-sm-2 mb-2" id="remember">
          <div class="custom-control custom-checkbox">
            <input class="custom-control-input" type="checkbox" id="checkbox-535-269" name="checkbox-535-269" value="Remember me" autocomplete="off"/>
            <label class="custom-control-label" for="checkbox-535-269">Remember me</label>
            <div class="valid-feedback"></div>
            <div class="invalid-feedback"></div>
          </div>
        </div>
        <button class="yonder-button btn btn-grey mb-2 yonder-form-submit" type="button" role="button" autocomplete="off">Log in</button>
      </form>
rdname: margin
sections: []
layout: doc
---

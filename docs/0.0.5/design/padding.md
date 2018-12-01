---
this: padding
filename: R/design.R
layout: page
requires: ~
roxygen:
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
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `0:5` or `"auto"` specifying
      a margin or padding for all sides of the tag element. 0 removes all
      space and 5 adds the most space.
  - name: top,right,bottom,left
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `0:5` or
      `"auto"`. 0 removes all space and 5 adds the most space.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Centering an element</h3>
  - type: markdown
    value: |
      <p>In most modern browsers you want to horizontally center a tag element using the flex layout. Alternatively, you can horizontally center an element using <code>margin(&lt;TAG&gt;, right = &quot;auto&quot;, left = &quot;auto&quot;)</code>.</p>
  - type: source
    value: |2-

      div(
        "Nam a sapien. Integer placerat tristique nisl.",
        style = "height: 100px; width: 200px;"
      ) %>%
        margin(top = 2, r = "auto", b = 2, l = "auto") %>%  # <-
        padding(3) %>%
        background("amber")
  - type: output
    value: '<div style="height: 100px; width: 200px;" class="mt-2 mr-auto mb-2 ml-auto
      p-3 bg-amber">Nam a sapien. Integer placerat tristique nisl.</div>'
  - type: markdown
    value: |
      <h3>Building an inline form</h3>
  - type: markdown
    value: |
      <p>Inline form elements automatically use of the flex layout providing you a means of creating condensed sets of inputs. However you may need to adjust the spacing of the form's child elements.</p>
  - type: markdown
    value: |
      <p>Here is an inline form without any additional spacing applied.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
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
            <input class="custom-control-input" type="checkbox" id="checkbox-636-930" data-value="Remember me"/>
            <label class="custom-control-label" for="checkbox-636-930">Remember me</label>
            <div class="invalid-feedback"></div>
            <div class="valid-feedback"></div>
          </div>
        </div>
        <button class="yonder-submit btn btn-blue" data-type="submit" role="button">Submit</button>
      </form>
  - type: markdown
    value: |
      <p>Not great. But, with some styling we can make this form sparkle. Notice we are also adjusting the default submit button added to the form input.</p>
  - type: source
    value: |2-

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
  - type: output
    value: |-
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
            <input class="custom-control-input" type="checkbox" id="checkbox-571-693" data-value="Remember me"/>
            <label class="custom-control-label" for="checkbox-571-693">Remember me</label>
            <div class="invalid-feedback"></div>
            <div class="valid-feedback"></div>
          </div>
        </div>
        <button class="yonder-submit btn btn-blue mb-2" data-type="submit" role="button">Log in</button>
      </form>
---

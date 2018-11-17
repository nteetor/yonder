---
this: groupInput
filename: R/group.R
layout: page
requires: ~
roxygen:
  title: Group inputs, combination button, dropdown, and text input
  description: |-
    A group input is a combination reactive input which may consist of one or two
    buttons, dropdowns, static addons, or any combination of these elements.
    Static addons, specified with `left` and `right` may be used to ensure an
    group input's reactive value always has a certain prefix or suffix. These
    static addons render with a shaded background to help indicated this behavior
    to the user. Buttons and dropdowns may be included to control when the group
    input's reactive value updates. See Details for more information.
  parameters:
  - name: id
    description: A character string specifying the id of the group input.
  - name: placeholder
    description: |-
      A character string specifying placeholder text for the
      input group, defaults to `NULL`.
  - name: value
    description: |-
      A character string specifying an initial value for the input
      group, defaults to `NULL`.
  - name: left,right
    description: |-
      A character vector specifying static addons or
      [buttonInput()](/yonder/0.0.5/inputs/buttonInput.html) or [dropdown()](/yonder/0.0.5/content/dropdown.html) elements specifying dynamic addons.
      Addon's affect the reactive value of the group input, see the Details
      section below for more information.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      parent element.
  sections:
  - title: '`left` and `right` combinations'
    body: |-
      **`left` is character or `right` is character**

      If `left` or `right` are character vectors, then the group input functions
      like a text input. The value will update and trigger a reactive event when
      the text box is modified. The group input's reactive value is the
      concatention of the static addons specified by `left` or `right` and the
      value of the text input.

      **`left` is button or `right` is button**

      The button does not change the value of the group input. However, the input
      no longer triggers event when the text box is updated. Instead the value
      is updated when a button is clicked. Static addons are still applied to the
      group input value.

      **`left` is a dropdown or `right` is a dropdown**

      The value of the group input does chance depending on the clicked dropdown
      menu item. The value of the input group is the concatentation of the
      dropdown input value, the value of the text input, and any static addons.
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Simple character string addon</h3>
  - type: markdown
    value: |
      <p>This input will always append a &quot;@&quot;.</p>
  - type: source
    value: |2-

      groupInput(
        id = NULL,
        left = "@",
        placeholder = "Username"
      )
  - type: output
    value: |-
      <div class="yonder-group input-group">
        <div class="input-group-prepend">
          <span class="input-group-text">@</span>
        </div>
        <input type="text" class="form-control" placeholder="Username"/>
      </div>
  - type: markdown
    value: |
      <h3>Text input and button combo</h3>
  - type: source
    value: |2-

      groupInput(
        id = NULL,
        placeholder = "Search terms",
        right = buttonInput(
          id = "button",
          label = "Go!"
        ) %>%
          background("transparent")
      )
  - type: output
    value: |-
      <div class="yonder-group input-group">
        <input type="text" class="form-control" placeholder="Search terms"/>
        <div class="input-group-append">
          <button class="yonder-button btn btn-grey bg-transparent" type="button" role="button" id="button">Go!</button>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Combination addon</h3>
  - type: source
    value: |2-

      groupInput(
        id = NULL,
        left = c("$", "0.")
      )
  - type: output
    value: |-
      <div class="yonder-group input-group">
        <div class="input-group-prepend">
          <span class="input-group-text">$</span>
          <span class="input-group-text">0.</span>
        </div>
        <input type="text" class="form-control"/>
      </div>
  - type: markdown
    value: |
      <h3>Two addons</h3>
  - type: source
    value: |2-

      groupInput(
        id = NULL,
        left = "@",
        placeholder = "Username",
        right = buttonInput(
          id = NULL,
          label = "Search"
        ) %>%
          background("transparent") %>%
          border("blue")
      )
  - type: output
    value: |-
      <div class="yonder-group input-group">
        <div class="input-group-prepend">
          <span class="input-group-text">@</span>
        </div>
        <input type="text" class="form-control" placeholder="Username"/>
        <div class="input-group-append">
          <button class="yonder-button btn btn-grey bg-transparent border border-blue" type="button" role="button">Search</button>
        </div>
      </div>
---

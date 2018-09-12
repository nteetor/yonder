---
this: buttonGroupInput
filename: R/button.R
layout: page
roxygen:
  title: Button group inputs
  description: Groups of buttons with a persisting value.
  parameters:
  - name: id
    description: A character string specifying the id of the button group input.
  - name: labels
    description: |-
      A character vector of labels, a button is added to the group
      for each label specified.
  - name: values
    description: |-
      A character vector of values, one for each button specified,
      defaults to `labels`.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Default input</h3>
  - type: source
    value: |2-

      buttonGroupInput(
        id = NULL,
        labels = c("Once", "Twice", "Thrice"),
        values = c(1, 2, 3)
      )
  - type: output
    value: |-
      <div class="yonder-button-group btn-group" role="group">
        <button type="button" class="btn" data-value="1">Once</button>
        <button type="button" class="btn" data-value="2">Twice</button>
        <button type="button" class="btn" data-value="3">Thrice</button>
      </div>
  - type: markdown
    value: |
      <h3>Styling the button group</h3>
  - type: source
    value: |2-

      buttonGroupInput(
        id = NULL,
        labels = c("Button 1", "Button 2", "Button 3")
      ) %>%
        background("blue") %>%
        margin(3)
  - type: output
    value: |-
      <div class="yonder-button-group btn-group bg-blue m-3" role="group">
        <button type="button" class="btn" data-value="Button 1">Button 1</button>
        <button type="button" class="btn" data-value="Button 2">Button 2</button>
        <button type="button" class="btn" data-value="Button 3">Button 3</button>
      </div>
---

---
this: icon
filename: R/icons.R
layout: page
roxygen:
  title: Icon elements
  description: Include icons in your application UIs.
  parameters:
  - name: name
    description: A character string specifying the name of the icon.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  - name: set
    description: |-
      A character string specifying the icon set to choose from,
        defaults to `"NULL"`, in which case all icon sets are searched.

        Possibles values include `"font awesome"`, `"material design"`, and
        `"feather"`.
  sections: ~
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Font awesome</h3>
  - type: source
    value: |2-

      icon("clone")
  - type: output
    value: <i class="fas fa-clone fa-fw"></i>
  - type: markdown
    value: |
      <h3>Material design</h3>
  - type: source
    value: |2-

      icon("mail", "material design")
  - type: output
    value: <i class="material-icons">mail</i>
  - type: markdown
    value: |
      <h3>Feather</h3>
  - type: source
    value: |2-

      icon("mail", "feather")
  - type: output
    value: |-
      <i data-feather="mail">
        <script>feather.replace()</script>
      </i>
---

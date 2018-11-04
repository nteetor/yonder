---
this: urlInput
filename: R/textual.R
layout: page
include: ~
roxygen:
  title: Textual inputs
  description: |-
    Different types of textual inputs are provided to best support mobile
    keyboards and assistive technologies. A password input will mask its
    contents. Email inputs offer client-side validation depending on the browser.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the textual input, defaults
      to `NULL`.
  - name: value
    description: |-
      A character string or a value coerced to a character string
      specifying the default value of the textual input.
  - name: placeholder
    description: |-
      A character string specifying placeholder text for the
      input, defaults to `NULL`, in which case there is no placeholder text.
  - name: size
    description: |-
      One of `"small"` or `"large"` specifying the size transformation
      of the input, defaults to `NULL`, in which case the input's size is
      unchanged.
  - name: readonly
    description: |-
      If `TRUE`, the textual input is read-only preventing
      modification of the value, defaults `FALSE`.
  - name: help
    description: |-
      A character string specifying the help text of the textual input,
      defaults to `NULL`, in which case no help text is added.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: []
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Basic text</h3>
  - type: source
    value: |2-

      textInput(id = "text")
  - type: output
    value: |-
      <div class="yonder-textual" id="text">
        <input class="form-control" type="text"/>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>Search</h3>
  - type: source
    value: |2-

      searchInput(id = "search")
  - type: output
    value: |-
      <div class="yonder-textual" id="search">
        <input class="form-control" type="search"/>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>Email</h3>
  - type: source
    value: |2-

      emailInput(id = "email")
  - type: output
    value: |-
      <div class="yonder-textual" id="email">
        <input class="form-control" type="email"/>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>URLs</h3>
  - type: source
    value: |2-

      urlInput(id = "url")
  - type: output
    value: |-
      <div class="yonder-textual" id="url">
        <input class="form-control" type="url"/>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>Telephone numbers</h3>
  - type: source
    value: |2-

      telephoneInput(id = "tele")
  - type: output
    value: |-
      <div class="yonder-textual" id="tele">
        <input class="form-control" type="tel"/>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>Passwords</h3>
  - type: source
    value: |2-

      passwordInput(id = "password")
  - type: output
    value: |-
      <div class="yonder-textual" id="password">
        <input class="form-control" type="password"/>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>Numbers</h3>
  - type: source
    value: |2-

      numberInput(id = "num")
  - type: output
    value: |-
      <div class="yonder-textual" id="num">
        <input class="form-control" type="number"/>
        <div class="invalid-feedback"></div>
      </div>
---

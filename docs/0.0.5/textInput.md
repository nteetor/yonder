---
this: textInput
filename: R/textual.R
layout: page
requires: ~
roxygen:
  title: Textual inputs
  description: |-
    Different types of textual inputs are provided to best support mobile
    keyboards and assistive technologies. A password input will mask its
    contents. Email inputs offer client-side validation depending on the browser.
  parameters:
  - name: value
    description: |-
      A character string or a value coerced to a character string
      specifying the default value of the textual input.
  - name: placeholder
    description: |-
      A character string specifying placeholder text for the
      input, defaults to `NULL`, in which case there is no placeholder text.
  sections: []
  return: ~
  family: ~
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

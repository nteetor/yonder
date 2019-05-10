---
name: urlInput
title: Textual inputs
description: |-
  Different types of textual inputs are provided to best support mobile
  keyboards and assistive technologies. A password input will mask its
  contents. Email inputs offer client-side validation depending on the browser.
inheritParams: checkboxInput
inheritParams: checkboxInput
parameters:
- name: value
  description: |-
    A character string or a value coerced to a character string
    specifying the default value of the textual input.
- name: placeholder
  description: |-
    A character string specifying placeholder text for the
    input, defaults to `NULL`, in which case there is no placeholder text.
family: inputs
export: ''
examples:
- title: Basic text
  body:
  - type: code
    content: textInput(id = "text")
    output: |-
      <div class="yonder-textual" id="text">
        <input class="form-control" type="text" autocomplete="off"/>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
- title: Search
  body:
  - type: code
    content: searchInput(id = "search")
    output: |-
      <div class="yonder-textual" id="search">
        <input class="form-control" type="search" autocomplete="off"/>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
- title: Email
  body:
  - type: code
    content: emailInput(id = "email")
    output: |-
      <div class="yonder-textual" id="email">
        <input class="form-control" type="email" autocomplete="off"/>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
- title: URLs
  body:
  - type: code
    content: urlInput(id = "url")
    output: |-
      <div class="yonder-textual" id="url">
        <input class="form-control" type="url" autocomplete="off"/>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
- title: Telephone numbers
  body:
  - type: code
    content: telephoneInput(id = "tele")
    output: |-
      <div class="yonder-textual" id="tele">
        <input class="form-control" type="tel" autocomplete="off"/>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
- title: Passwords
  body:
  - type: code
    content: passwordInput(id = "password")
    output: |-
      <div class="yonder-textual" id="password">
        <input class="form-control" type="password" autocomplete="off"/>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
- title: Numbers
  body:
  - type: code
    content: numberInput(id = "num")
    output: |-
      <div class="yonder-textual" id="num">
        <input class="form-control" type="number" autocomplete="off"/>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
rdname: urlInput
sections: []
layout: doc
---

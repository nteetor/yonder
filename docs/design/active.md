---
name: active
title: Color selected choices
description: Use `active()` to change the highlight color of an input's selected choices.
parameters:
- name: tag
  description: A tag element.
- name: color
  description: |-
    One of `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
    `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`, `"white"`
    specifying the active color of selected choices.
family: design
export: ''
examples:
- title: Radiobar example
  body:
  - type: code
    content: |-
      radiobarInput(
        id = "radio1",
        choices = c("Hello", "Goodnight", "Howdy")
      ) %>%
        width(16) %>%
        active("orange")  # <-
    output: |-
      <div class="yonder-radiobar btn-group btn-group-toggle d-flex w-16 active-orange" id="radio1" data-toggle="buttons">
        <label class="btn btn-grey active">
          <input name="radio1" type="radio" value="Hello" checked autocomplete="off"/>
          Hello
        </label>
        <label class="btn btn-grey">
          <input name="radio1" type="radio" value="Goodnight" autocomplete="off"/>
          Goodnight
        </label>
        <label class="btn btn-grey">
          <input name="radio1" type="radio" value="Howdy" autocomplete="off"/>
          Howdy
        </label>
      </div>
- title: Checkbox example
  body:
  - type: code
    content: |-
      checkboxInput(
        id = "check1",
        choices = c("Rock", "Paper", "Scissors"),
        selected = "Rock"
      ) %>%
        active("teal")
    output: |-
      <div class="yonder-checkbox active-teal" id="check1">
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-807-890" name="checkbox-807-890" value="Rock" checked autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-807-890">Rock</label>
        </div>
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-96-994" name="checkbox-96-994" value="Paper" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-96-994">Paper</label>
        </div>
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-385-816" name="checkbox-385-816" value="Scissors" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-385-816">Scissors</label>
          <div class="valid-feedback"></div>
          <div class="invalid-feedback"></div>
        </div>
      </div>
rdname: active
sections: []
layout: doc
---

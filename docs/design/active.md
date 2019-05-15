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
          <input class="custom-control-input" type="checkbox" id="checkbox-553-294" name="checkbox-553-294" value="Rock" checked autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-553-294">Rock</label>
        </div>
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-664-987" name="checkbox-664-987" value="Paper" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-664-987">Paper</label>
        </div>
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-430-712" name="checkbox-430-712" value="Scissors" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-430-712">Scissors</label>
          <div class="valid-feedback"></div>
          <div class="invalid-feedback"></div>
        </div>
      </div>
- title: Chip input
  body:
  - type: code
    content: |-
      chipInput(
        id = "chip1",
        choices = c("Ether", "Bombos", "Quake"),
        selected = "Ether"
      ) %>%
        width("1/2") %>%
        active("green")
    output: |-
      <div id="chip1" class="yonder-chip btn-group dropup w-1/2 active-green" data-max="-1">
        <input class="form-control" data-toggle="dropdown"/>
        <div class="dropdown-menu">
          <button class="dropdown-item selected" value="Ether">Ether</button>
          <button class="dropdown-item" value="Bombos">Bombos</button>
          <button class="dropdown-item" value="Quake">Quake</button>
        </div>
        <div class="chips chips-inline chips-grey">
          <button class="chip active" value="Ether">
            <span class="chip-content">Ether</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip" value="Bombos">
            <span class="chip-content">Bombos</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip" value="Quake">
            <span class="chip-content">Quake</span>
            <span class="chip-close">&times;</span>
          </button>
        </div>
      </div>
rdname: active
sections: []
layout: doc
---

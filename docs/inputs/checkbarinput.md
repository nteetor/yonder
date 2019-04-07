---
name: checkbarInput
title: Checkbox inputs
description: |-
  Reactive checkbox and checkbar inputs. Users may select one or more choices.
  The checkbox input appears as a standard checkbox or set of checkboxes. The
  checkbar input appears similar to a group of buttons, but with a checked or
  highlighted state. When a checkbox or checkbar input has no selected choices
  the reactive value is `NULL`. Switch inputs differ from checkboxes only in
  appearance.
inheritParams: buttonInput
parameters:
- name: choices
  description: |-
    A character string or vector specifying a label for the
    checkbox or checkbar.
- name: values
  description: |-
    A character string or vector specifying values for the
    checkbox or checkbar input, defaults to `choice` or `values`, respectively.
- name: selected
  description: |-
    One or more of `values` specifying which choices are
    selected by default, defaults to `NULL`, in which case no choices are
    initially selected.
- name: inline
  description: |-
    One of `TRUE` or `FALSE` specifying if the checkbox input
    choices render inline or stacked, defaults to `FALSE`, in which case the
    choices are stacked.
family: inputs
export: ''
examples:
- title: One option
  body:
  - type: code
    content: |-
      checkboxInput(
        id = "checkbox1",
        choices = "Choice 1",
        selected = "Choice 1"
      )
    output: |-
      <div class="yonder-checkbox" id="checkbox1">
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-508-257" name="checkbox1" value="Choice 1" checked autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-508-257">Choice 1</label>
          <div class="invalid-feedback"></div>
        </div>
      </div>
- title: Multiple options
  body:
  - type: code
    content: |-
      checkboxInput(
        id = "checkbox2",
        choices = c("Choice 1", "Choice 2")
      )
    output: |-
      <div class="yonder-checkbox" id="checkbox2">
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-767-956" name="checkbox2" value="Choice 1" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-767-956">Choice 1</label>
          <div class="invalid-feedback"></div>
        </div>
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-839-932" name="checkbox2" value="Choice 2" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-839-932">Choice 2</label>
          <div class="invalid-feedback"></div>
        </div>
      </div>
- title: Inline checkbox
  body:
  - type: code
    content: |-
      checkboxInput(
        id = "checkbox3",
        choices = c("Choice 1", "Choice 2", "Choice 3"),
        inline = TRUE
      )
    output: |-
      <div class="yonder-checkbox" id="checkbox3">
        <div class="custom-control custom-checkbox custom-control-inline">
          <input class="custom-control-input" type="checkbox" id="checkbox-37-881" name="checkbox3" value="Choice 1" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-37-881">Choice 1</label>
          <div class="invalid-feedback"></div>
        </div>
        <div class="custom-control custom-checkbox custom-control-inline">
          <input class="custom-control-input" type="checkbox" id="checkbox-302-508" name="checkbox3" value="Choice 2" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-302-508">Choice 2</label>
          <div class="invalid-feedback"></div>
        </div>
        <div class="custom-control custom-checkbox custom-control-inline">
          <input class="custom-control-input" type="checkbox" id="checkbox-304-793" name="checkbox3" value="Choice 3" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-304-793">Choice 3</label>
          <div class="invalid-feedback"></div>
        </div>
      </div>
- title: Checkbar
  body:
  - type: code
    content: |-
      checkbarInput(
        id = "checks",
        choices = c(
          "Check 1",
          "Check 2",
          "Check 3"
        ),
        selected = "Check 1"
      ) %>%
        background("blue") %>%
        margin(2)
    output: |-
      <div class="yonder-checkbar btn-group btn-group-toggle d-flex m-2" id="checks" data-toggle="buttons">
        <label class="btn active btn-blue">
          <input type="checkbox" autocomplete="off" value="Check 1" checked/>
          Check 1
        </label>
        <label class="btn btn-blue">
          <input type="checkbox" autocomplete="off" value="Check 2"/>
          Check 2
        </label>
        <label class="btn btn-blue">
          <input type="checkbox" autocomplete="off" value="Check 3"/>
          Check 3
        </label>
      </div>
- title: Labeling a checkbar
  body:
  - type: code
    content: |-
      formGroup(
        label = "Toppings",
        checkbarInput(
          id = "fixins",
          choices = c(
            "Sprinkles",
            "Nuts",
            "Fudge"
          )
        )
      )
    output: |-
      <div class="form-group">
        <label>Toppings</label>
        <div class="yonder-checkbar btn-group btn-group-toggle d-flex" id="fixins" data-toggle="buttons">
          <label class="btn btn-grey">
            <input type="checkbox" autocomplete="off" value="Sprinkles"/>
            Sprinkles
          </label>
          <label class="btn btn-grey">
            <input type="checkbox" autocomplete="off" value="Nuts"/>
            Nuts
          </label>
          <label class="btn btn-grey">
            <input type="checkbox" autocomplete="off" value="Fudge"/>
            Fudge
          </label>
        </div>
      </div>
- title: Switches
  body:
  - type: code
    content: |-
      switchInput(
        id = "switch1",
        choices = paste("Switch choice", 1:3),
        selected = "Switch choice 3"
      ) %>%
        active("indigo")
    output: |-
      <div class="yonder-checkbox active-indigo" id="switch1">
        <div class="custom-control custom-switch">
          <input class="custom-control-input" type="checkbox" id="checkbox-835-277" name="switch1" value="Switch choice 1" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-835-277">Switch choice 1</label>
          <div class="invalid-feedback"></div>
        </div>
        <div class="custom-control custom-switch">
          <input class="custom-control-input" type="checkbox" id="checkbox-76-409" name="switch1" value="Switch choice 2" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-76-409">Switch choice 2</label>
          <div class="invalid-feedback"></div>
        </div>
        <div class="custom-control custom-switch">
          <input class="custom-control-input" type="checkbox" id="checkbox-471-982" name="switch1" value="Switch choice 3" checked autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-471-982">Switch choice 3</label>
          <div class="invalid-feedback"></div>
        </div>
      </div>
rdname: checkbarInput
sections: []
layout: doc
---

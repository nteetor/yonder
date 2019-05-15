---
name: checkboxInput
title: Checkbox inputs
description: |-
  Reactive checkbox and checkbar inputs. Users may select one or more choices.
  The checkbox input appears as a standard checkbox or set of checkboxes. The
  checkbar input appears similar to a group of buttons, but with a checked or
  highlighted state. When a checkbox or checkbar input has no selected choices
  the reactive value is `NULL`. Switch inputs differ from checkboxes only in
  appearance.
parameters:
- name: id
  description: A character string specifying the id of the reactive input.
- name: choices
  description: |-
    A character string or vector specifying a label or labels for
    the checkbox or checkbar.
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
- name: '...'
  description: |-
    Additional named arguments passed as HTML attributes to the
    parent element or tag elements passed as child elements to the parent
    element.
- name: enable
  description: |-
    One of `values` specifying particular choices to enable or
    `TRUE` specifying the entire input is enabled, defaults to `NULL`.
- name: disable
  description: |-
    One of `values` specifying particular choices to disable or
    `TRUE` specifying the entire input is disabled, defaults to `NULL`.
- name: valid
  description: |-
    A character string specifying a message to the user indicating
    how the input's value is valid, defaults to `NULL.`
- name: invalid
  description: |-
    A character string specifying a message to the user
    indicating how the input's value is invalid, defaults to `NULL`.
- name: session
  description: A reactive context, defaults to [getDefaultReactiveDomain()](getdefaultreactivedomain.html).
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
          <input class="custom-control-input" type="checkbox" id="checkbox-552-390" name="checkbox-552-390" value="Choice 1" checked autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-552-390">Choice 1</label>
          <div class="valid-feedback"></div>
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
          <input class="custom-control-input" type="checkbox" id="checkbox-275-644" name="checkbox-275-644" value="Choice 1" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-275-644">Choice 1</label>
        </div>
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-701-690" name="checkbox-701-690" value="Choice 2" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-701-690">Choice 2</label>
          <div class="valid-feedback"></div>
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
          <input class="custom-control-input" type="checkbox" id="checkbox-835-805" name="checkbox-835-805" value="Choice 1" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-835-805">Choice 1</label>
        </div>
        <div class="custom-control custom-checkbox custom-control-inline">
          <input class="custom-control-input" type="checkbox" id="checkbox-535-624" name="checkbox-535-624" value="Choice 2" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-535-624">Choice 2</label>
        </div>
        <div class="custom-control custom-checkbox custom-control-inline">
          <input class="custom-control-input" type="checkbox" id="checkbox-33-403" name="checkbox-33-403" value="Choice 3" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-33-403">Choice 3</label>
          <div class="valid-feedback"></div>
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
          <input class="custom-control-input" type="checkbox" id="checkbox-167-406" name="checkbox-167-406" value="Switch choice 1" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-167-406">Switch choice 1</label>
        </div>
        <div class="custom-control custom-switch">
          <input class="custom-control-input" type="checkbox" id="checkbox-14-738" name="checkbox-14-738" value="Switch choice 2" autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-14-738">Switch choice 2</label>
        </div>
        <div class="custom-control custom-switch">
          <input class="custom-control-input" type="checkbox" id="checkbox-378-680" name="checkbox-378-680" value="Switch choice 3" checked autocomplete="off"/>
          <label class="custom-control-label" for="checkbox-378-680">Switch choice 3</label>
          <div class="valid-feedback"></div>
          <div class="invalid-feedback"></div>
        </div>
      </div>
rdname: checkboxInput
sections: []
layout: doc
---

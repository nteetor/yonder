---
name: fieldset
title: Group and label multiple inputs
description: |-
  Use `fieldset` to associate and label inputs. This is good for screen readers
  and other assistive technologies.
parameters:
- name: legend
  description: A character string specifying the fieldset's legend.
- name: '...'
  description: |-
    Any number of inputs to group or named arguments passed as HTML
    attributes to the parent element.
family: layout
export: ''
examples:
- title: Grouping related inputs
  body:
  - type: code
    content: |-
      fieldset(
        legend = "Pizza order",
        formGroup(
          "What toppings would you like?",
          div(
            checkbarInput(
              id = "toppings",
              choices = c(
                "Cheese",
                "Black olives",
                "Mushrooms"
              )
            )
          )
        ),
        formGroup(
          "Is this for delivery?",
          checkboxInput(
            id = "deliver",
            choice = "Deliver"
          )
        ),
        submitInput("Place order")
      )
    output: |-
      <fieldset class="form-group">
        <legend class="col-form-legend">Pizza order</legend>
        <div>
          <div class="form-group">
            <label>What toppings would you like?</label>
            <div>
              <div class="yonder-checkbar btn-group btn-group-toggle" data-toggle="buttons" id="toppings">
                <label class="btn btn-grey">
                  <input type="checkbox" autocomplete="off" value="Cheese"/>
                  Cheese
                </label>
                <label class="btn btn-grey">
                  <input type="checkbox" autocomplete="off" value="Black olives"/>
                  Black olives
                </label>
                <label class="btn btn-grey">
                  <input type="checkbox" autocomplete="off" value="Mushrooms"/>
                  Mushrooms
                </label>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label>Is this for delivery?</label>
            <div class="yonder-checkbox" id="deliver">
              <div class="custom-control custom-checkbox">
                <input class="custom-control-input" type="checkbox" id="checkbox-913-302" name="deliver" value="Deliver"/>
                <label class="custom-control-label" for="checkbox-913-302">Deliver</label>
                <div class="invalid-feedback"></div>
              </div>
            </div>
          </div>
          <button class="yonder-submit btn btn-blue" role="button" value="Place order">Place order</button>
        </div>
      </fieldset>
rdname: fieldset
sections: []
layout: doc
---

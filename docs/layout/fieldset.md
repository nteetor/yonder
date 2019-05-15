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
        buttonInput("order", "Place order") %>%
          background("blue")
      )
    output: |-
      <fieldset class="form-group">
        <legend class="col-form-legend">Pizza order</legend>
        <div>
          <div class="form-group">
            <label>What toppings would you like?</label>
            <div>
              <div class="yonder-checkbar btn-group btn-group-toggle d-flex" id="toppings" data-toggle="buttons">
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
                <input class="custom-control-input" type="checkbox" id="checkbox-623-210" name="checkbox-623-210" value="Deliver" autocomplete="off"/>
                <label class="custom-control-label" for="checkbox-623-210">Deliver</label>
                <div class="valid-feedback"></div>
                <div class="invalid-feedback"></div>
              </div>
            </div>
          </div>
          <button class="yonder-button btn btn-blue" type="button" role="button" id="order" autocomplete="off">Place order</button>
        </div>
      </fieldset>
rdname: fieldset
sections: []
layout: doc
---

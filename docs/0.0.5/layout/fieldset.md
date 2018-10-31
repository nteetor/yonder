---
this: fieldset
filename: R/forms.R
layout: page
roxygen:
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
  sections: []
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Grouping related inputs</h3>
  - type: source
    value: |2-

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
  - type: output
    value: |-
      <fieldset class="form-group">
        <legend class="col-form-legend">Pizza order</legend>
        <div>
          <div class="form-group">
            <label>What toppings would you like?</label>
            <div>
              <div class="yonder-checkbar btn-group btn-group-toggle" data-toggle="buttons" id="toppings">
                <label class="btn btn-grey">
                  <input type="checkbox" autocomplete="off" data-value="Cheese"/>
                  <span>Cheese</span>
                </label>
                <label class="btn btn-grey">
                  <input type="checkbox" autocomplete="off" data-value="Black olives"/>
                  <span>Black olives</span>
                </label>
                <label class="btn btn-grey">
                  <input type="checkbox" autocomplete="off" data-value="Mushrooms"/>
                  <span>Mushrooms</span>
                </label>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label>Is this for delivery?</label>
            <div class="yonder-checkbox" id="deliver">
              <div class="custom-control custom-checkbox">
                <input class="custom-control-input" type="checkbox" id="checkbox-900-399" data-value="Deliver"/>
                <label class="custom-control-label" for="checkbox-900-399">Deliver</label>
                <div class="invalid-feedback"></div>
                <div class="valid-feedback"></div>
              </div>
            </div>
          </div>
          <button class="yonder-submit btn btn-blue" data-type="submit" role="button">Place order</button>
        </div>
      </fieldset>
---

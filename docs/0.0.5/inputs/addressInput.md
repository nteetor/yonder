---
this: addressInput
filename: R/textual.R
layout: page
roxygen:
  title: Address input
  description: |-
    A composite input which includes a street field, apartment or unit field,
    city field, state field, and a zip code field.
  parameters:
  - name: id
    description: A character string specifying the id of the address input.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      top-level element.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Fields by default</h3>
  - type: source
    value: |2-

      addressInput(id = NULL)
  - type: output
    value: |-
      <div class="yonder-address">
        <div class="form-group">
          <label for="address-941-433" class="col-form-label">Address</label>
          <input type="text" class="form-control" id="address-941-433" placeholder="Street address, P.O. box"/>
        </div>
        <div class="form-group">
          <label for="address-986-614" class="form-control-label sr-only">Address line 2</label>
          <input type="text" class="form-control" id="address-986-614" placeholder="Apartment, floor, unit"/>
        </div>
        <div class="form-row">
          <div class="form-group col-md-6 mt-auto">
            <label class="form-control-label" for="address-736-733">City</label>
            <input type="text" class="form-control" id="address-736-733"/>
          </div>
          <div class="form-group col-md-3">
            <label class="form-control-label" for="address-100-181">State</label>
            <input type="text" class="form-control" id="address-100-181"/>
          </div>
          <div class="form-group col-md-3 mt-auto">
            <label class="form-control-label" for="address-853-408">Zip</label>
            <input type="text" class="form-control" id="address-853-408"/>
          </div>
        </div>
      </div>
---

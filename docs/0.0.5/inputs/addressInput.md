---
this: addressInput
filename: R/textual.R
layout: page
requires: ~
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
  sections: []
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Default fields</h3>
  - type: source
    value: |2-

      addressInput(id = "mailing")
  - type: output
    value: |-
      <div class="yonder-address" id="mailing">
        <div class="form-group">
          <label for="address-58-839" class="col-form-label">Address</label>
          <input type="text" class="form-control" id="address-58-839" placeholder="Street address, P.O. box"/>
        </div>
        <div class="form-group">
          <label for="address-672-585" class="form-control-label sr-only">Address line 2</label>
          <input type="text" class="form-control" id="address-672-585" placeholder="Apartment, floor, unit"/>
        </div>
        <div class="form-row">
          <div class="form-group col-md-6 mt-auto">
            <label class="form-control-label" for="address-306-81">City</label>
            <input type="text" class="form-control" id="address-306-81"/>
          </div>
          <div class="form-group col-md-3">
            <label class="form-control-label" for="address-735-353">State</label>
            <input type="text" class="form-control" id="address-735-353"/>
          </div>
          <div class="form-group col-md-3 mt-auto">
            <label class="form-control-label" for="address-784-564">Zip</label>
            <input type="text" class="form-control" id="address-784-564"/>
          </div>
        </div>
      </div>
---

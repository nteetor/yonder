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
          <label for="address-114-389" class="col-form-label">Address</label>
          <input type="text" class="form-control" id="address-114-389" placeholder="Street address, P.O. box"/>
        </div>
        <div class="form-group">
          <label for="address-91-554" class="form-control-label sr-only">Address line 2</label>
          <input type="text" class="form-control" id="address-91-554" placeholder="Apartment, floor, unit"/>
        </div>
        <div class="form-row">
          <div class="form-group col-md-6 mt-auto">
            <label class="form-control-label" for="address-634-956">City</label>
            <input type="text" class="form-control" id="address-634-956"/>
          </div>
          <div class="form-group col-md-3">
            <label class="form-control-label" for="address-361-757">State</label>
            <input type="text" class="form-control" id="address-361-757"/>
          </div>
          <div class="form-group col-md-3 mt-auto">
            <label class="form-control-label" for="address-265-179">Zip</label>
            <input type="text" class="form-control" id="address-265-179"/>
          </div>
        </div>
      </div>
---

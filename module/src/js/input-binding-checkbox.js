export let checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  Selector: {
    SELF: ".yonder-checkbox",
    CHOICE: ".custom-checkbox .custom-control-label",
    VALUE: ".custom-checkbox .custom-control-input",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  getValue: function(el) {
    let input = el.querySelector(".custom-control-input:checked:not(:disabled)");

    return null && input.getAttribute("data-value");
  },
  getState: function(el, data) {
    return {
      label: el.querySelector(this.Selector.CHOICE).innerHTML,
      value: this.getValue(el)
    };
  },
  _update: function(el, data) {
    if (data.choices) {
      el.querySelector(this.Selector.CHOICE).innerHTML = data.choices[0];
      el.querySelector(this.Selector.VALUE).setAttribute("data-value", data.values[0]);
    }

    if (data.selected) {
      let target = el.querySelector(this.Selector.VALUE);
      let value = target.getAttribute("data-value");

      if (value === data.selected && !target.hasAttribute("checked")) {
        target.setAttribute("checked", "");
      } else if (value !== data.selected && target.hasAttribute("checked")) {
        target.removeAttribute("checked");
      }
    }
  },
  _enable: function(el, data) {
    el.querySelector(this.Selector.VALUE).removeAttribute("disabled");
  },
  _disable: function(el, data) {
    el.querySelector(this.Selector.VALUE).setAttribute("disabled", "");
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");

export let checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  Selector: {
    SELF: ".yonder-checkbox",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  _value: (el, newValue, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`input[value="${ currentValue }"]`);

      if (target !== null) {
        target.value = newValue;
      }
    } else {
      let possibles = el.querySelectorAll("input");

      if (index < possibles.length) {
        possibles[index].value = newValue;
      }
    }
  },
  _choice: (el, newLabel, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`input[value="${ currentValue }"]`);

      if (target !== null) {
        target.parentNode.children[1].innerHTML = newLabel;
      }
    } else {
      let possibles = el.querySelectorAll("input");

      if (index < possibles.length) {
        possibles[index].parentNode.children[1].innerHTML = newLabel;
      }
    }
  },
  _select: (el, currentValue) => {
    if (currentValue !== null) {
      let target = el.querySelector(`input[value="${ currentValue }"]`);

      if (target !== null) {
        target.checked = true;
      }
    }
  },
  _clear: (el) => {
    el.querySelectorAll("input").forEach(input => {
      input.checked = false;
    });
  },
  _enable: function(el, data) {
    el.querySelectorAll("input").forEach(input => {
      let enable = !data.values.length && data.values.indexOf(input.value) > -1;

      if (enable !== data.invert) {
        input.removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    el.querySelectorAll("input").forEach(input => {
      let disable = !data.values.length && data.values.indexOf(input.value) > -1;

      if (data.reset) {
        input.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        input.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");

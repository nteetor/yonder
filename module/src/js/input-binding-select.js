export let selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  Selector: {
    SELF: ".yonder-select",
    SELECTED: "option:checked:not(:disabled)",
    VALIDATE: "select"
  },
  Events: [
    { type: "change" }
  ],
  _value: (el, newValue, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`option[value="${ currentValue }"]`);
      if (target !== null) {
        target.value = newValue;
      }
    } else {
      let possibles = el.querySelectorAll("option");

      if (index < possibles.length) {
        possibles[index].value = newValue;
      }
    }
  },
  _choice: (el, newLabel, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`option[value="${ currentValue }"]`);
      if (target !== null) {
        target.innerHTML = newLabel;
      }
    } else {
      let possibles = el.querySelectorAll("option");

      if (index < possibles.length) {
        possibles[index].innerHTML = newLabel;
      }
    }
  },
  _select: (el, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`option[value="${ currentValue }"]`);
      if (target !== null) {
        target.setAttribute("selected", "");
      }
    } else {
      let possibles = el.querySelectorAll("option");
      if (index < possibles.length) {
        possibles[index].setAttribute("selected", "");
      }
    }
  },
  _clear: (el) => {
    el.querySelectorAll("option").forEach(op => op.removeAttribute("selected"));
  },
  _enable: (el, data) => {
    el.querySelectorAll("option").forEach(opt => {
      let enable = !data.values.length || data.values.indexOf(opt.value);

      if (enable !== data.invert) {
        opt.removeAttribute("disabled");
      }
    });
  },
  _disable: (el, data) => {
    el.querySelectorAll("option").forEach(opt => {
      let disable = !data.values.length || data.values.indexOf(opt.value);

      if (data.reset) {
        opt.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        opt.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");

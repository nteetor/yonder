export let radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  Selector: {
    SELF: ".yonder-radio[id]",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  _value: (el, newValue, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.custom-control-input[value="${ currentValue }"]`);
      if (target !== null) {
        target.value = newValue;
      }
    } else {
      let possibles = el.querySelectorAll(".custom-control-input");
      if (index < possibles.length) {
        possibles[index].value = newValue;
      }
    }
  },
  _choice: (el, newLabel, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.custom-control-input[value="${ currentValue }"]`);
      if (target !== null) {
        target.nextElementSibling.innerHTML = newLabel;
      }
    } else {
      let possibles = el.querySelectorAll(".custom-control-label");
      if (index < possibles.length) {
        possibles[index].innerHTML = newLabel;
      }
    }
  },
  _select: (el, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.custom-control-input[value="${ currentValue }"]`);
      if (target !== null) {
        target.setAttribute("checked", "");
      }
    } else {
      let possibles = el.querySelectorAll(".custom-control-input");
      if (index < possibles.length) {
        possibles[index].setAttribute("checked", "");
      }
    }
  },
  _clear: function(el) {
    el.querySelector(this.Selector.SELECTED).removeAttribute("checked");
  },
  _enable: (el, data) => {
    el.querySelectorAll(".custom-control-input").forEach(input => {
      let enable = !data.values.length || data.values.indexOf(input.value) > -1;

      if (enable !== data.invert) {
        input.classList.removeAttribute("disabled");
      }
    });
  },
  _disable: (el, data) => {
    el.querySelectorAll(".custom-control-input").forEach(input => {
      let disable = !data.values.length || data.values.indexOf(input.value) > -1;

      if (data.reset) {
        input.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        input.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(radioInputBinding, "yonder.radioInput");

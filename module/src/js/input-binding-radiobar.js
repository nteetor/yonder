export let radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  Selector: {
    SELF: ".yonder-radiobar[id]",
    SELECTED: "input:checked:not(:disabled)"
  },
  Events: [
    { type: "click" },
    { type: "change" }
  ],
  _value: (el, newValue, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`input[value="${ currentValue }"]`);

      if (target !== null) {
        target.value = newValue;
      }
    } else {
      let inputs = el.querySelectorAll("input");

      if (index < inputs.length) {
        inputs[index].value = newValue;
      }
    }
  },
  _choice: (el, newLabel, currentValue, index) => {
    if (currentValue !== null)  {
      let target = el.querySelector(`input[value="${ currentValue }"]`);

      if (target !== null) {
        target.parentNode.children[1].innerHTML = newLabel;
      }
    } else {
      let inputs = el.querySelectorAll("input");

      if (index < inputs.length) {
        inputs[index].parentNode.children[1].innerHTML = newLabel;
      }
    }
  },
  _select: (el, currentValue) => {
    if (currentValue !== null) {
      let target = el.querySelector(`input[value="${ currentValue }"]`);

      if (target !== null) {
        target.checked = true;
        target.parentNode.classList.add("active");
      }
    }
  },
  _clear: (el) => {
    el.querySelectorAll("input:checked").forEach(input => {
      input.checked = false;
      input.parentNode.classList.remove("active");
    });
  },
  _enable: function(el, data) {
    let values = data.values;
    el.querySelectorAll("input").forEach(input => {
      let enable = !values.length || values.indexOf(input.value) > -1;

      if (enable !== data.invert) {
        input.parentNode.classList.remove("disabled");
        input.removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let values = data.values;
    el.querySelectorAll("input").forEach(input => {
      let disable = !values.length || values.indexOf(input.value) > -1;

      if (data.reset) {
        input.parentNode.classList.remove("disabled");
        input.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        input.parentNode.classList.add("disabled");
        input.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(radiobarInputBinding, "yonder.radiobarInput");

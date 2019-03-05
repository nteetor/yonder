export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".yonder-button"
  },
  Events: [
    {
      type: "click",
      callback: el => el.value = +el.value + 1
    }
  ],
  initialize: (el) => {
    el.value = 0;
  },
  getValue: (el) => {
    return +el.value > 0 ? +el.value : null;
  },
  _update: (el, data) => {
    el.innerHTML = data.choices[0];

    if (data.choices !== data.values) {
      el.value = parseInt(data.values[0], 10) || 0;
    }
  },
  _enable: (el, data) => {
    if (!data.invert) {
      el.classList.remove("disabled");
      el.removeAttribute("disabled");
    }
  },
  _disable: (el, data) => {
    if (!data.invert) {
      el.classList.add("disabled");
      el.setAttribute("disabled", "");
    }
  }
});

Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");

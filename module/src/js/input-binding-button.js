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
  _choice: (el, newLabel, currentValue, index) => {
    el.innerHTML = newLabel;
  },
  _value: (el, newValue, currentValue, index) => {
    if (+newValue === +newValue) {
      el.value = newValue;
    }
  },
  _select: (el, currentValue, index) => {
    // cannot select
  },
  _clear: (el) => {
    // no need to do anything
  },
  _enable: (el, data) => {
    if (!data.invert) {
      el.classList.remove("disabled");
    }
  },
  _disable: (el, data) => {
    if (!data.invert) {
      el.classList.add("disabled");
    }
  }
});

Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");

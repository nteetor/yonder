export let buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  Selector: {
    SELF: ".yonder-button-group"
  },
  Events: [
    {
      type: "click",
      selector: "button",
      callback: (el, e, self) => {
        self._VALUES[el.id] = e.currentTarget.value;
      }
    }
  ],
  _VALUES: {},
  getType: (el) => "yonder.buttonGroup",
  initialize: function(el) {
    this._VALUES[el.id] = null;
  },
  getValue: function(el) {
    return { force: Date.now(), value: this._VALUES[el.id] };
  },
  _choice: (el, newLabel, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`button[value="${ currentValue }"]`);

      if (target !== null) {
        target.innerHTML = newLabel;
      }
    } else {
      let buttons = el.querySelectorAll("button");

      if (index < buttons.length) {
        buttons[index].innerHTML = newLabel;
      }
    }
  },
  _value: (el, newValue, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`button[value="${ currentValue }"]`);

      if (target !== null) {
        target.value = newValue;
      }
    } else {
      let buttons = el.querySelectorAll("button");

      if (index < buttons.length) {
        buttons[index].value = newValue;
      }
    }
  },
  _select: () => null,
  _clear: () => null,
  _enable: function(el, data) {
    let values = data.values;

    el.querySelectorAll("button").forEach(button => {
      let enable = !values.length || values.indexOf(button.value) > -1;

      if (enable !== data.invert) {
        button.classList.remove("disabled");
        button.removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let values = data.values;

    el.querySelectorAll("button").forEach(button => {
      let disable = !values.length || values.indexOf(button.value) > -1;

      if (data.reset) {
        button.classList.remove("disabled");
        button.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        button.classList.add("disabled");
        button.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");

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
  _update: (el, data) => {
    let template = el.querySelector("button").cloneNode();
    template.removeAttribute("disabled");

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode();
      child.innerHTML = choice;
      child.value = data.values[i];

      el.appendChild(child);
    });
  },
  _enable: function(el, data) {
    let values = data.values;

    el.querySelectorAll("button").forEach(button => {
      let enable = !values.length || values.indexOf(button.value) > -1;

      if (enable !== data.invert) {
        button.removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let values = data.values;

    el.querySelectorAll("button").forEach(button => {
      let disable = !values.length || values.indexOf(button.value) > -1;

      if (data.reset) {
        button.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        button.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");

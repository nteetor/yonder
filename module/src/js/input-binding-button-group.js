export let buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  Selector: {
    "SELF": ".yonder-button-group",
    "CHOICE": ".btn",
    "VALUE": ".btn"
  },
  Events: [
    {
      "type": "click",
      "selector": "button",
      "callback": (el, target, self) => self._VALUES[el.id] = target.getAttribute("data-value")
    }
  ],
  _VALUES: {},
  getType: (el) => "yonder.buttonGroup",
  getValue: function(el) {
    return { "force": Date.now(), "value": this._VALUES[el.id] };
  },
  _update: (el, data) => {
    if (data.choices) {
      let children = document.querySelectorAll(".btn");

      children.forEach((child, i) => {
        child.innerHTML = data.choices[i];
        child.setAttribute("data-value", data.values[i]);
      });
    }

    // can't "select"
  },
  _enable: function(el, data) {
    let children = el.querySelectorAll(this.Selector.CHILD);

    children.forEach(child => {
      let value = child.querySelector(this.Selector.VALUE).getAttribute("data-value");
      let index = data.values ? data.values.indexOf(value) : 0;

      if ((index > -1) === !data.invert) {
        child.classList.remove("disabled");
        child.querySelector(this.Selector.VALUE).removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let children = el.querySelectorAll(this.Selector.CHILD);

    children.forEach(child => {
      let value = child.querySelector(this.Selector.VALUE).getAttribute("data-value");
      let index = data.values ? data.values.indexOf(value) : 0;

      if ((index > -1) === !data.invert) {
        child.classList.add("disabled");
        child.querySelector(this.Selector.VALUE).setAttribute("disabled", "");
      } else if (data.reset) {
        child.classList.remove("disabled");
        child.querySelector(this.Selector.VALUE).removeAttribute("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");

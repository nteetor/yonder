export let menuInputBinding = new Shiny.InputBinding();

$.extend(menuInputBinding, {
  Selector: {
    SELF: ".yonder-menu",
    CHOICE: ".dropdown-item",
    VALUE: ".dropdown-item",
    SELECTED: ".active"
  },
  Events: [
    {
      type: "click",
      selector: "a",
      callback: el => false
    },
    {
      type: "click",
      selector: ".dropdown-item:not(.disabled)",
      callback: (el, target, self) => self._VALUES[el.id] = target.getAttribute("data-value")
    }
  ],
  _VALUES: {},
  find: function(scope) {
    return scope.querySelectorAll(`:not(.nav) > ${ this.Selector.SELF }[id]`);
  },
  initialize: function(el) {
    this._VALUES[el.id] = null;
  },
  getType: el => "yonder.menu",
  getValue: function(el) {
    return { force: Date.now(), value: this._VALUES[el.id] };
  },
  _update: function(el, data) {
    let children = el.querySelectorAll(this.Selector.CHOICE);

    children.forEach((child, i) => {
      child.innerText = data.choices[i];
      child.setAttribute("data-value", data.values[i]);
    });
  },
  _enable: function(el, data) {
    let children = el.querySelectorAll(this.Selector.CHOICE);

    children.forEach(child => {
      let value = child.getAttribute("data-value");
      let index = data.values ? data.values.indexOf(value) : 0;

      if ((index > -1) === !data.invert) {
        child.classList.remove("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let children = el.querySelectorAll(this.Selector.CHOICE);

    children.forEach(child => {
      let value = child.getAttribute("data-value");
      let index = data.values ? data.values.indexOf(value) : 0;

      if ((index > -1) === !data.invert) {
        child.classList.add("disabled");
      } else if (data.reset) {
        child.classList.remove("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

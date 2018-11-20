export let buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  Selector: {
    "SELF": ".yonder-button-group[id]",
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
    let children = document.querySelectorAll(".btn"); // modularize?

    if (!children.length) {
      return false;
    }

    let choices, values;

    if (data.choices === null) {
      choices = children.forEach(child => child.innerHTML);
    }

    let template = children[0].cloneNode();

    for (const child of children) {
      el.removeChild(child);
    }

    for (const i in data.values) {
      const [name, value] = data.values[i];

      template.setAttribute("data-value", value);
      template.innerHTML = name;
      el.appendChild(template.cloneNode(true));
    }

    return true;
  }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");

export let checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  Selector: {
    SELF: ".yonder-checkbar[id]",
    VALUE: ".btn input",
    SELECTED: ".btn:not(.disabled) input:checked"
  },
  Events: [
    { type: "change", selector: ".btn" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  _update: function(el, data) {
    let buttons = el.querySelectorAll(".btn");

    if (!buttons.length) {
      return false;
    }

    let template = buttons[0].cloneNode(true);
    template.classList.remove("active");

    for (const child of buttons) {
      el.removeChild(child);
    }

    for (var i = data.choices.length - 1; i >= 0; i--) {
      template.querySelector("span").innerHTML = data.choices[i];

      template
        .querySelector("input")
        .setAttribute("data-value", data.values[i]);

      el.insertBefore(template.cloneNode(true), el.firstChild);
    }

    if (data.selected !== null) {
      let selected = el.querySelector(`.btn:nth-child(${ data.selected })`);

      if (selected !== null) {
        selected.classList.add("active");
      }
    }

    return true;
  },
  _enable: function(el, data) {
    let buttons = el.querySelectorAll(".btn");

    for (const button of buttons) {
      let value = button.querySelector("input").getAttribute("data-value");
      let index = data.values.indexOf(value);

      if ((index > -1) === !data.invert) {
        button.classList.remove("disabled");
        button.querySelector("input").removeAttribute("disabled");
      }
    }
  },
  _disable: function(el, data) {
    let buttons = el.querySelectorAll(".btn");

    for (const button of buttons) {
      let value = button.querySelector("input").getAttribute("data-value");
      let index = data.values.indexOf(value);

      if ((index > -1) === !data.invert) {
        button.classList.add("disabled");
        button.querySelector("input").setAttribute("disabled", "");
      } else if (data.reset) {
        button.classList.remove("disabled");
        button.querySelector("input").removeAttribute("disabled");
      }
    }
  }
});

Shiny.inputBindings.register(checkbarInputBinding, "yonder.checkbarInput");

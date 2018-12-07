export let radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  Selector: {
    SELF: ".yonder-radiobar[id]",
    VALUE: ".btn input",
    LABEL: ".btn > span",
    SELECTED: ".btn input:checked"
  },
  Events: [
    { type: "click" },
    { type: "change" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  _update: function(el, data) {
    let children = el.querySelectorAll(".btn");

    if (data.choices) {
      children.forEach((child, i) => {
        child.querySelector("span").innerHTML = data.choices[i];
        child.querySelector("input").setAttribute("data-value", data.values[i]);
      });
    }

    if (data.selected) {
      el.querySelector(".active").classList.remove(".active");
      el.querySelector(`input[data-value=${ data.selected }]`)
        .parentNode.classList.add("active");
    }
  },
  _enable: function(el, data) {
    let children = el.querySelectorAll(".btn");

    children.forEach(child => {
      let input = child.querySelector("input");
      let value = input.getAttribute("data-value");
      let index = data.values ? data.values.indexOf(value) : 0;

      if ((index > -1) === !data.invert) {
        child.classList.remove("disabled");
        input.removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let children = el.querySelectorAll(".btn");

    children.forEach(child => {
      let input = child.querySelector("input");
      let value = input.getAttribute("data-value");
      let index = data.values ? data.values.indexOf(value) : 0;

      if ((index > -1) === !data.invert) {
        child.classList.add("disabled");
        input.setAttribute("disabled", "");
      } else if (data.reset) {
        child.classList.remove("disabled");
        input.removeAttribute("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(radiobarInputBinding, "yonder.radiobarInput");

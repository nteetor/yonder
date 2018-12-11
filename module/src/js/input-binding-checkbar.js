export let checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  Selector: {
    SELF: ".yonder-checkbar",
    CHOICE: ".btn span",
    VALUE: ".btn input",
    SELECTED: "input:checked"
  },
  Events: [
    { type: "change", selector: ".btn" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  _update: function(el, data) {
    if (data.choices) {
      let children = el.querySelectorAll(".btn");

      children.forEach((child, i) => {
        child.querySelector("span").innerHTML = data.choices[i];
        child.querySelector("input").setAttribute("data-value", data.values[i]);
      });
    }

    if (data.selected) {
      let current = el.querySelector(".active");

      if (current !== null) {
        current.classList.remove("active");
      }

      data.selected
        .map(s => el.querySelector(`label[data-value="${ s }"]`))
        .filter(child => child !== null)
        .forEach(child => child.classList.add("active"));
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

Shiny.inputBindings.register(checkbarInputBinding, "yonder.checkbarInput");

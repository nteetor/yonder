export let selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  Selector: {
    SELF: ".yonder-select[id]",
    VALUE: "option",
    SELECTED: "option:checked",
    VALIDATE: "select"
  },
  Events: [
    { type: "change" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  _update: function(el, data) {
    let select = el.querySelector("select");
    let options = select.querySelectorAll("option");

    if (!options.length) {
      return false;
    }

    let template = options[0].cloneNode();
    template.removeAttribute("selected");
    select.innerHTML = "";

    for (var i = 0; i < data.choices.length; i++) {
      template.innerHTML = data.choices[i];
      template.value = data.values[i];

      select.appendChild(template.cloneNode(true));
    }

    select
      .querySelector(`option:nth-child(${ data.selected })`)
      .setAttribute("selected", "");

    return true;
  },
  _enable: function(el, data) {
    let options = el.querySelectorAll("option");

    for (const option of options) {
      let value = option.getAttribute("data-value");
      let index = data.values.indexOf(value);

      if ((index > -1) === !data.invert) {
        option.removeAttribute("disabled");
      }
    }
  },
  _disable: function(el, data) {
    let options = el.querySelectorAll("option");

    for (const option of options) {
      let value = option.getAttribute("data-value");
      let index = data.values.indexOf(value);

      if ((index > -1) === !data.invert) {
        option.setAttribute("disabled", "");
      } else if (data.reset) {
        option.removeAttribute("disabled");
      }
    }
  }
});

Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");

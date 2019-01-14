export let selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  Selector: {
    SELF: ".yonder-select",
    SELECTED: "option:checked:not(:disabled)",
    VALIDATE: "select"
  },
  Events: [
    { type: "change" }
  ],
  _update: (el, data) => {
    let template = el.querySelector("option").cloneNode();
    template.removeAttribute("selected");
    template.removeAttribute("disabled");

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode();
      child.innerText = choice;
      child.value = data.values[i];

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.setAttribute("selected", "");
      }

      el.appendChild(child);
    });
  },
  _enable: (el, data) => {
    el.querySelectorAll("option").forEach(opt => {
      let enable = !data.values.length || data.values.indexOf(opt.value);

      if (enable !== data.invert) {
        opt.removeAttribute("disabled");
      }
    });
  },
  _disable: (el, data) => {
    el.querySelectorAll("option").forEach(opt => {
      let disable = !data.values.length || data.values.indexOf(opt.value);

      if (data.reset) {
        opt.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        opt.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");

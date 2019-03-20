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
    let select = el.children[0];
    let template = el.querySelector("option").cloneNode();
    template.removeAttribute("selected");
    template.removeAttribute("disabled");

    select.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode();
      child.innerText = choice;
      child.value = data.values[i];

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.selected = true;
      }

      select.appendChild(child);
    });
  },
  _select: (el, data) => {
    el.querySelectorAll("option").forEach(child => {
      let value = child.value;

      if (data.reset === true) {
        child.removeAttribute("selected");
      }

      let match = data.fixed ? data.pattern.indexOf(value) > -1 :
          RegExp(data.pattern, "i").test(value);

      if (match !== data.invert) {
        el.querySelector("select").value = value;
      }
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

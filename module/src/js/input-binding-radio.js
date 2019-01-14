export let radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  Selector: {
    SELF: ".yonder-radio[id]",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".custom-radio").cloneNode(true);
    template.children[0].removeAttribute("checked", "");

    el.innerHTML = "";

    data.chocies.forEach((choice, i) => {
      let child = template.cloneNode(true);
      child.children[1].innerHTML = choice;
      child.children[0].value = data.values[i];

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.children[0].setAttribute("checked", "");
      }

      el.appendChild(child);
    });
  },
  _enable: (el, data) => {
    el.querySelectorAll(".custom-control-input").forEach(input => {
      let enable = !data.values.length || data.values.indexOf(input.value) > -1;

      if (enable !== data.invert) {
        input.removeAttribute("disabled");
      }
    });
  },
  _disable: (el, data) => {
    el.querySelectorAll(".custom-control-input").forEach(input => {
      let disable = !data.values.length || data.values.indexOf(input.value) > -1;

      if (data.reset) {
        input.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        input.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(radioInputBinding, "yonder.radioInput");

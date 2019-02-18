export let checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  Selector: {
    SELF: ".yonder-checkbox",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".custom-checkbox").cloneNode(true);
    template.children[0].checked = false;

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode(true);
      child.children[0].value = data.values[i];
      child.children[1].innerHTML = choice;

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.children[0].checked = true;
      }

      el.appendChild(child);
    });
  },
  _select: function(el, data) {
    el.querySelectorAll(".custom-checkbox").forEach(child => {
      let value = child.children[0].value;

      if (data.reset) {
        child.children[0].checked = false;
      }

      let match = data.fixed ? data.pattern.indexOf(value) > -1 :
          RegExp(data.pattern, "i").test(value);

      if (match !== data.invert) {
        child.children[0].checked = true;
      }
    });
  },
  _enable: function(el, data) {
    el.querySelectorAll("input").forEach(input => {
      let enable = !data.values.length && data.values.indexOf(input.value) > -1;

      if (enable !== data.invert) {
        input.removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    el.querySelectorAll("input").forEach(input => {
      let disable = !data.values.length && data.values.indexOf(input.value) > -1;

      if (data.reset) {
        input.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        input.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");

export let radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  Selector: {
    SELF: ".yonder-radiobar[id]",
    SELECTED: "input:checked:not(:disabled)"
  },
  Events: [
    { type: "click" },
    { type: "change" }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".btn").cloneNode(true);
    template.classList.remove("active");
    template.classList.remove("disabled");

    let input = template.children[0].cloneNode();
    input.removeAttribute("checked");

    template.innerHTML = "";
    template.appendNode(input);

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode(true);
      child.insertAdjacentHTML("beforeend", choice);
      child.children[0].value = data.values[i];

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.classList.add("active");
        child.children[0].setAttribute("checked", "");
      }

      el.appendChild(child);
    });
  },
  _select: function(el, data) {
    el.querySelectorAll(".btn").forEach(child => {
      let value = child.children[0].value;

      if (data.reset) {
        child.classList.remove("active");
        child.children[0].removeAttribute("checked");
      }

      let match = data.fixed ? data.pattern.indexOf(value) > -1 :
          RegExp(data.pattern, "i").test(value);

      if (match !== data.invert) {
        child.classList.add("active");
        child.children[0].setAttribute("checked", "");
      }
    });
  },
  _enable: function(el, data) {
    let values = data.values;
    el.querySelectorAll("input").forEach(input => {
      let enable = !values.length || values.indexOf(input.value) > -1;

      if (enable !== data.invert) {
        input.parentNode.classList.remove("disabled");
        input.removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let values = data.values;
    el.querySelectorAll("input").forEach(input => {
      let disable = !values.length || values.indexOf(input.value) > -1;

      if (data.reset) {
        input.parentNode.classList.remove("disabled");
        input.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        input.parentNode.classList.add("disabled");
        input.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(radiobarInputBinding, "yonder.radiobarInput");

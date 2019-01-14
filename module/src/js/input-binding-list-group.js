export let listGroupInputBinding = new Shiny.InputBinding();

$.extend(listGroupInputBinding, {
  Selector: {
    SELF: ".yonder-list-group",
    SELECTED: ".list-group-item-action.active:not(.disabled)"
  },
  Events: [
    {
      type: "click",
      selector: ".list-group-item-action:not(.disabled)",
      callback: (el, e, self) => {
        if (el.getAttribute("data-multiple") === "false") {
          el.querySelectorAll(".list-group-item-action:not(.disabled)")
            .forEach(li => li.classList.remove("active"));
        }

        e.currentTarget.classList.toggle("active");
      }
    }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".list-group-item").cloneNode();
    template.classList.remove("active");
    template.classList.remove("disabled");

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode();
      child.innerHTML = choice;
      child.setAttribute("data-value", data.values[i]);

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.classList.add("active");
      }

      el.appendChild(child);
    });
  },
  _enable: (el, data) => {
    let values = data.values;
    el.querySelectorAll(".list-group-item").forEach(li => {
      let enable = !values.length || values.indexOf(li.getAttribute("data-value")) > -1;

      if (enable !== data.invert) {
        li.classList.remove("disabled");
      }
    });
  },
  _disable: (el, data) => {
    let values = data.values;
    el.querySelectorAll(".list-group-item").forEach(li => {
      let disable = !values.length || values.indexOf(li.getAttribute("data-value")) > -1;

      if (data.reset) {
        li.classList.remove("disabled");
      }

      if (disable !== data.invert) {
        li.classList.add("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

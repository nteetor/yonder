export let listGroupInputBinding = new Shiny.InputBinding();

$.extend(listGroupInputBinding, {
  Selector: {
    SELF: ".yonder-list-group",
    SELECTED: ".active:not(.disabled)"
  },
  Events: [
    {
      type: "click",
      selector: ".list-group-item-action:not(.active):not(.disabled)",
      callback: (el, event, _) => {
        el.querySelectorAll(".active")
          .forEach(item => item.classList.remove("active"));

        event.currentTarget.classList.add("active");
      }
    },
    {
      type: "click",
      selector: ".active:not(.disabled)",
      callback: (el, event, _) => {
        event.currentTarget.classList.remove("active");
      }
    }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".list-group-item").cloneNode();
    template.classList.remove("active");
    template.classList.remove("disabled");

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let item = template.cloneNode();
      item.innerHTML = choice;
      item.value = data.values[i];

      if (data.selected.indexOf(data.values[i]) > -1) {
        item.classList.add("active");
      }

      el.appendChild(item);
    });
  },
  _select: function(el, data) {
    el.querySelectorAll(".list-group-item").forEach(item => {
      let value = item.value;

      if (data.reset) {
        item.classList.remove("active");
      }

      let match = data.fixed ? data.pattern.indexOf(value) > -1 :
          RegExp(data.pattern, "i").test(value);

      if (match !== data.invert) {
        item.classList.add("active");
      }
    });
  },
  _enable: (el, data) => {
    let values = data.values;
    el.querySelectorAll(".list-group-item").forEach(item => {
      let enable = !values.length || values.indexOf(item.value) > -1;

      if (enable !== data.invert) {
        item.classList.remove("disabled");
      }
    });
  },
  _disable: (el, data) => {
    let values = data.values;
    el.querySelectorAll(".list-group-item").forEach(item => {
      let disable = !values.length || values.indexOf(item.value) > -1;

      if (data.reset) {
        item.classList.remove("disabled");
      }

      if (disable !== data.invert) {
        item.classList.add("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

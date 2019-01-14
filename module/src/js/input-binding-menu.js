export let menuInputBinding = new Shiny.InputBinding();

$.extend(menuInputBinding, {
  Selector: {
    SELF: ".yonder-menu",
    SELECTED: ".dropdown-item.active"
  },
  Events: [
    {
      type: "click",
      selector: ".dropdown-item:not(.disabled)",
      callback: (el, e) => {
        let active = el.querySelector(".dropdown-item.active");
        if (active !== null) {
          active.classList.remove("active");
        }
        e.currentTarget.classList.add("active");
      }
    },
    {
      type: "nav.reset",
      callback: (el) => {
        let active = el.querySelector(".dropdown-item.active");
        if (active !== null) {
          active.classList.remove("active");
        }
      }
    }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".dropdown-item").cloneNode();
    template.removeClass("disabled");
    template.removeClass("active");

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode();
      child.innerHTML = choice;
      child.value = data.values[i];

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.classList.add("active");
      }

      el.appendChild(child);
    });
  },
  _enable: function(el, data) {
    el.querySelectorAll(".dropdown-item").forEach(di => {
      let enable = !data.values.length || data.values.indexOf(di.value) > -1;

      if (enable !== data.invert) {
        di.classList.remove("disabled");
      }
    });
  },
  _disable: function(el, data) {
    el.querySelectorAll(".dropdown-item").forEach(di => {
      let disable = !data.values.length || data.values.indexOf(di.value) > -1;

      if (data.reset) {
        di.classList.remove("disabled");
      }

      if (disable !== data.invert) {
        di.classList.add("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

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
        e.target.classList.add("active");
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
  _value: (el, newValue, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.dropdown-item[value="${ currentValue }"]`);
      if (target !== null) {
        target.value = newValue;
      }
    } else {
      let possibles = el.querySelectorAll(".dropdown-item");
      if (index < possibles.length) {
        possibles[index].value = newValue;
      }
    }
  },
  _choice: (el, newLabel, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.dropdown-item[value="${ currentValue }"]`);
      if (target !== null) {
        target.innerHTML = newLabel;
      }
    } else {
      let possibles = el.querySelectorAll(".dropdown-item");
      if (index < possibles.length) {
        possibles[index].innerHTML = newLabel;
      }
    }
  },
  _select: (el, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.dropdown-item[value="${ currentValue }"]`);
      if (target !== null) {
        target.classList.add("active");
      }
    } else {
      let possibles = el.querySelectorAll(".dropdown-item");
      if (index < possibles.length) {
        possibles[index].classList.add("active");
      }
    }
  },
  _clear: (el) => {
    el.querySelectorAll(".dropdown-item.active")
      .forEach(di => di.classList.remove("active"));
  },
  _enable: function(el, data) {
    el.querySelectorAll(".dropdown-item").forEach(di => {
      let enable = !data.values.length || data.values.indexOf(di.value) > -1;

      if (enable && !data.invert) {
        di.classList.remove("disabled");
      }
    });
  },
  _disable: function(el, data) {
    el.querySelectorAll(".dropdown-item").forEach(di => {
      let disable = !data.values.length || data.values.indexOf(di.value) > -1;

      if (disable && !data.invert) {
        di.classList.add("disabled");
      } else if (data.reset) {
        di.classList.remove("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

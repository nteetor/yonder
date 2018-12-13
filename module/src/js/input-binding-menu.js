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
      callback: (el, target) => {
        let active = el.querySelector(".dropdown-item.active");
        if (active) {
          active.classList.remove("active");
        }
        target.classList.add("active");
      }
    },
    {
      type: "change",
      selector: ".dropdown-item:not(.disabled)"
    }
  ],
  Type: "yonder.menu",
  find: function(scope) {
    return scope.querySelectorAll(`:not(.nav) > ${ this.Selector.SELF }[id]`);
  },
  getValue: function(el) {
    let selected = el.querySelector(".dropdown-item.active");
    return { force: Date.now(), value: selected && selected.value };
  },
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
    let children = el.querySelectorAll(".dropdown-item");

    children.forEach(child => {
      let enable = !data.values.length || data.values.indexOf(child.value) > -1;

      if (enable && !data.invert) {
        child.classList.remove("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let children = el.querySelectorAll(".dropdown-item");

    children.forEach(child => {
      let disable = !data.values.length || data.values.indexOf(child.value) > -1;

      if (disable && !data.invert) {
        child.classList.add("disabled");
      } else if (data.reset) {
        child.classList.remove("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

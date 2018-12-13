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

        e.target.classList.toggle("active");
      }
    }
  ],
  _value: (el, newValue, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.list-group-item[data-value="${ currentValue }"]`);
      if (target !== null) {
        target.setAttribute("data-value", newValue);
      }
    } else {
      let possibles = el.querySelectorAll(".list-group-item");

      if (index < possibles.length) {
        possibles[index].setAttribute("data-value", newValue);
      }
    }
  },
  _choice: (el, newLabel, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.list-group-item[data-value"${ currentValue }"]`);
      if (target !== null) {
        target.innerHTML = newLabel;
      }
    } else {
      let possibles = el.querySelectorAll(".list-group-item");

      if (index < possibles.length) {
        possibles[index].innerHTML = newLabel;
      }
    }
  },
  _select: (el, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.list-group-item[data-value="${ currentValue }"]`);
      if (target !== null) {
        target.classList.add("active");
      }
    } else {
      let possibles = el.querySelectorAll(".list-group-item");
      if (index < possibles.length) {
        possibles[index].classList.add("active");
      }
    }
  },
  _clear: (el) => {
    el.querySelectorAll(".list-group-item").forEach(li => li.classList.remove("active"));
  },
  _enable: (el, data) => {
    let values = data.values;
    el.querySelectorAll(".list-group-item").forEach(li => {
      let enable = !values.length || values.indexOf(li.getAttribute("data-value")) > -1;

      if (enable && !data.invert) {
        li.classList.remove("disabled");
      }
    });
  },
  _disable: (el, data) => {
    let values = data.values;
    el.querySelectorAll(".list-group-item").forEach(li => {
      let disable = !values.length || values.indexOf(li.getAttribute("data-value")) > -1;

      if (disable && !data.invert) {
        li.classList.add("disabled");
      } else if (data.reset) {
        li.classList.remove("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

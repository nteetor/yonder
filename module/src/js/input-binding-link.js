export let linkInputBinding = new Shiny.InputBinding();

$.extend(linkInputBinding, {
  Selector: {
    SELF: ".yonder-link[id]"
  },
  Events: [
    {
      type: "click",
      callback: (el) => el.value = +el.value + 1
    }
  ],
  Type: "yonder.link",
  initialize: function(el) {
    el.value = 0;
  },
  getValue: (el) => {
    return +el.value > 0 ? +el.value : null;
  },
  _value: (el, newValue, currentValue, index) => {
    el.value = newValue;
  },
  _choice: (el, newLabel, currentValue, index) => {
    el.innerHTML = newLabel;
  },
  _select: () => null,
  _clear: () => null,
  _disable: function(el, data) {
    el.classList.add("disabled");
    el.setAttribute("disabled", "");
  },
  _enable: function(el, data) {
    el.classList.remove("disabled");
    el.removeAttribute("disabled");
  }
});

Shiny.inputBindings.register(linkInputBinding, "yonder.linkInput");

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
  initialize: function(el) {
    el.value = 0;
  },
  getValue: (el) => {
    return +el.value > 0 ? +el.value : null;
  },
  _update: (el, data) => {
    el.value = data.values[0];
    el.innerText = data.choices[0];
  },
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

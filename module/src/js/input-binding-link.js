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
  getValue: function(el) {
    return { value: +el.value, id: el.id };
  },
  _update: function(el, data) {
    if (data.choices.length) {
      el.innerHTML = data.choices[0];
    }

    if (data.values.length) {
      el.value = data.values[0];
    }
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

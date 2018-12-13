export let groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  Selector: {
    SELF: ".yonder-group[id]",
    VALUE: "input",
    SELECTED: ".input-group-prepend .input-group-text, input, .input-group-append .input-group-text",
  },
  Events: [
    { type: "input", debounce: true },
    { type: "change", debounce: true }
  ],
  Type: "yonder.group",
  getValue: function(el) {
    return Array.prototype.slice.call(el.querySelectorAll(this.Selector.SELECTED))
      .map(s => /^(DIV|SPAN)$/.test(s.tagName) ? s.innerText : (s.value || null))
      .filter(value => value !== null);
  },
  _update: function(el, data) {
    if (data.values) {
      let input = el.querySelector("input");
      input.value = data.values[0];
    }
  },
  _enable: function(el, data) {
    el.querySelector("input").removeAttribute("disabled");
  },
  _disable: function(el, data) {
    el.querySelector("input").setAttribute("disabled", "");
  },
  _validate: function(el, data) {
    el.querySelector("input").classList.remove("is-invalid");
  },
  _invalidate: function(el, data) {
    el.querySelector("input").classList.add("is-invalid");
  }
});

Shiny.inputBindings.register(groupInputBinding, "yonder.groupInput");

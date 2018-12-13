export let groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  Selector: {
    SELF: ".yonder-group[id]",
    SELECTED: ".input-group-prepend .input-group-text, input, .input-group-append .input-group-text",
    VALIDATE: "input"
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
  _value: (el, newValue, currentValue, index) => {
    el.querySelector("input").value = newValue;
  },
  _choice: () => null,
  _select: () => null,
  _clear: () => null,
  _enable: function(el, data) {
    el.querySelector("input").removeAttribute("disabled");
  },
  _disable: function(el, data) {
    el.querySelector("input").setAttribute("disabled", "");
  }
});

Shiny.inputBindings.register(groupInputBinding, "yonder.groupInput");

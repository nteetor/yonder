export let linkInputBinding = new Shiny.InputBinding();

$.extend(linkInputBinding, {
  Selector: {
    SELF: ".dull-link-input"
  },
  Events: [
    { type: "click", callback: (el) => el.dataset.value++ }
  ],
  initialize: function(el) {
    el.dataset.value = 0;
  },
  getType: function(el) {
    return "dull.link";
  },
  getValue: function(el) {
    return {
      value: el.dataset.value,
      id: el.id
    };
  }
});

// Shiny.inputBindings.register(linkInputBindng, "dull.linkInput");

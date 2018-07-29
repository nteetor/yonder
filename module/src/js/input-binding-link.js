export let linkInputBinding = new Shiny.InputBinding();

$.extend(linkInputBinding, {
  Selector: {
    SELF: ".yonder-link[id]"
  },
  Events: [
    {
      type: "click",
      callback: el => el.setAttribute("data-value", +el.getAttribute("data-value") + 1)
    }
  ],
  initialize: function(el) {
    el.setAttribute("data-value", 0);
  },
  getType: function(el) {
    return "yonder.link";
  },
  getValue: function(el) {
    return {
      value: el.getAttribute("data-value"),
      id: el.id
    };
  }
});

export let linkInputBinding = new Shiny.InputBinding();

$.extend(linkInputBinding, {
  Selector: {
    SELF: ".yonder-link[id]"
  },
  Events: [
    {
      "type": "click",
      "callback": (el, _, self) => self._VALUES[el.id] += 1
    }
  ],
  _VALUES: {},
  initialize: function(el) {
    this._VALUES[el.id] = 0;
  },
  getType: function(el) {
    return "yonder.link";
  },
  getValue: function(el) {
    return {
      "value": this._VALUES[el.id],
      "id": el.id
    };
  }
});

Shiny.inputBindings.register(linkInputBinding, "yonder.linkInput");

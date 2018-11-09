export let buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  Selector: {
    SELF: ".yonder-button-group[id]",
    VALUE: ".btn",
    LABEL: ".btn"
  },
  Events: [
    {
      "type": "click",
      "selector": "button",
      "callback": (el, target, self) => self._VALUES[el.id] = target.getAttribute("data-value")
    }
  ],
  _VALUES: {},
  getType: (el) => "yonder.buttonGroup",
  getValue: function(el) {
    return { "force": Date.now(), "value": this._VALUES[el.id] };
  },
  // subscribe: function(el, callback) {
  //   $(el).on("click.buttonGroupInputBinding", "button", (e) => {
  //     this._VALUES[el.id] = e.target.getAttribute("data-value");
  //     callback();
  //   });
  // },
  // unsubscribe: function(el) {
  //   $(el).off(".buttonGroupInputBinding", "button");
  // }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");

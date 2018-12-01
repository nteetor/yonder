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
  },
  _update: function(el, data) {
    if (data.choices !== null) {
      el.innerHTML = data.choices[0];
    }

    if (data.values !== null) {
      this._VALUES[el.id] = data.values[0];
    }
  },
  _disable: function(el, data) {
    el.classList.add("disabled");
    $(el).on("click.disable", e => false);
  },
  _enable: function(el, data) {
    el.classList.remove("disabled");
    $(el).off(".disable");
  }
});

Shiny.inputBindings.register(linkInputBinding, "yonder.linkInput");

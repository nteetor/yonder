export let formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  Events: [
    {
      type: "click",
      selector: ".yonder-submit",
      callback: (el, target, self) => {
        self._VALUES[el.id] = target.value;
        $(el.querySelectorAll(".shiny-bound-input")).trigger("submission.yonder");
      }
    }
  ],
  Type: "yonder.form",
  _VALUES: {},
  find: function(scope) {
    let forms = Array.prototype.slice.call(scope.querySelectorAll(".yonder-form[id]"));

    return forms.filter(f => f.querySelector(".yonder-submit") !== null);
  },
  initialize: function(el) {
    this._VALUES[el.id] = null;
  },
  getValue: function(el) {
    return { force: Date.now(), value: this._VALUES[el.id] };
  }
});

Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

let checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  Selector: {
    SELF: ".dull-checkbox-input",
    VALUE: ".custom-control-input",
    LABEL: ".custom-control-label",
    SELECTED: ".custom-control-input:checked:not(:disabled)"
  },
  getValue: function(el) {
    var $val = $(el)
      .find(`${ this.Selector.SELECTED }`)
      .data("value");
    return $val === undefined ? null : $val;
  },
  _getLabel: function(el) {
    return $(el).find(`${ this.Selector.LABEL }`).text();
  },
  getState: function(el, data) {
    return {
      label: this._getLabel(el),
      value: this.getValue(el)
    };
  },
  subscribe: function(el, callback) {
    $(el).on("change.checkboxInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".checkboxInputBinding");
  }
  // receiveMessage: function(el, data) {
  //   if (data.type === "update:choices") {
  //     this.updateChoices(el, data.data);
  //     return;
  //   }

  //   var $el = $(el);

  //    if (data.validate !== undefined) {
  //     $("input", el).removeClass("is-invalid")
  //       .addClass("is-valid");

  //     return;
  //   }

  //   if (data.invalidate !== undefined) {
  //     $("input", el).addClass("is-invalid");
  //     $(".invalid-feedback", el).html(data.invalidate);

  //     return;
  //   }

  //   $el.trigger("change");
  // }
});

Shiny.inputBindings.register(checkboxInputBinding, "dull.checkboxInput");

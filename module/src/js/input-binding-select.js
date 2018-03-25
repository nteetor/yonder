var selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  Selector: {
    SELF: ".dull-select-input",
    VALUE: "option",
    LABEL: "option",
    SELECTED: "option:checked",
    VALIDATE: "select"
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.selectInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".selectInputBinding");
  }
  // receiveMessage: function(el, data) {
  //   if (data.validate !== undefined) {
  //     $("select", el).removeClass("is-invalid")
  //       .addClass("is-valid");

  //     return;
  //   }

  //   if (data.invalidate !== undefined) {
  //     $("select", el).addClass("is-invalid");
  //     $(".invalid-feedback", el).html(data.invalidate);

  //     return;
  //   }
  // }
});

Shiny.inputBindings.register(selectInputBinding, "dull.selectInput");

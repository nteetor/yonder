export let formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  Events: [
    { type: "submit" }
  ],
  find: function(scope) {
    let $input = $(scope).find(".dull-form-input[id]");

    if (!$input.children("button[data-type='submit']").length) {
      return null;
    }

    return $input;
  }
});

// Shiny.inputBindings.register(formInputBinding, "dull.formInput");

(function() {
  this.getType = function(el) {
    if ($(el).parents(".dull-form-input[id]").length) {
      return "dull.form.element";
    }
  };
}).call(Shiny.InputBinding.prototype);

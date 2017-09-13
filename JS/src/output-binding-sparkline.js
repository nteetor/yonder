var sparklineOutputBinding = new Shiny.OutputBinding();

$.extend(sparklineOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-sparkline-output[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    if (data.values) {
      var $el = $(el);

      var labels = $el.data("labels");

      $el.text(function(i, c) {
        let contents = "{" + data.values.join(",") + "}";

        if (labels) {
          contents = data.raw[0] + contents + data.raw[data.raw.length - 1];
        }

        if (c === "") {
          return contents;
        } else {
          return c.replace(/{[0-9,]*}/, contents);
        }
      });
    }
  },
  renderError: function(el, data) {

  },
  clearError: function(el) {

  }
});

Shiny.outputBindings.register(sparklineOutputBinding, "dull.sparklineOutput");

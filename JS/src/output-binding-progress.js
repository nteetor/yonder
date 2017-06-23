var barOutputBinding = new Shiny.OutputBinding();

$.extend(barOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-bar[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    var $el = $(el);

    if (data.value !== null) {
      $el.attr("style", "width: " + data.value + "%");
    }

    if (data.label !== null) {
      $el.text(data.label);
    }

    /*
    $.each(data, function(key, value) {
      console.log(key + ": " + value);
    });
    */
  }
});

Shiny.outputBindings.register(barOutputBinding, "dull.barOutput");


/*
$.extend(Shiny.progressHandlers, {
  dull: function(message) {
    console.log("this worked?");
    console.log(message);
  }
});
*/

var breadcrumbOutputBinding = new Shiny.OutputBinding();

$.extend(breadcrumbOutputBinding, {
  find: function(scope) {
    return $(scope).find(".buckle-breadcrumb");
  },
  getValue: function(el) {
    return $(el).find("li:last").text();
  }
});

/* THIS IS A STUB */

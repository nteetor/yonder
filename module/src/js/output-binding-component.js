var componentOutputBinding = new Shiny.OutputBinding();

$.extend(componentOutputBinding, {
  find: (scope) => {
    return $(scope).find(".dull-component-output");
  },
  renderValue: (el, data) => {
    Shiny.renderContent(el, data);
  }
});

Shiny.outputBindings.register(componentOutputBinding, "dull.componentOutput");

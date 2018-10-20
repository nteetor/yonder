// input
export let listGroupInputBinding = new Shiny.InputBinding();

$(() => {
  $(".yonder-list-group[id]").on("click", ".list-group-item-action", (e) => {
    e.target.classList.toggle("active");
    return true;
  });
});

$.extend(listGroupInputBinding, {
  find: (scope) => $(scope).find(".yonder-list-group[id]"),

  getId: (el) => el.id,

  getValue: (el) => {
    return $(el)
      .children(".list-group-item.active:not(.disabled)")
      .map((index, item) => $(item).data("value"))
      .get();
  },

  getState: function(el, data) {
    return { value: this.getValue(el) };
  },

  subscribe: (el, callback) => {
    $(el).on("change.listGroupInputBinding", (e) => callback());
  },

  unsubscribe: (el) => $(el).off(".listGroupInputBinding")
});

// output
export let listGroupOutputBinding = new Shiny.OutputBinding();

$.extend(listGroupOutputBinding, {
  find: (scope) => $(scope).find(".yonder-list-group[id]"),

  getId: (el) => el.id,

  renderValue: (el, data) => {
    if (!data.items) {
      return;
    }

    let items = typeof data.items === "object" ? Object.values(data.items) : data.items;

    Shiny.renderContent(el, items.join("\n"));
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");
Shiny.outputBindings.register(listGroupOutputBinding, "yonder.listGroupOutput");

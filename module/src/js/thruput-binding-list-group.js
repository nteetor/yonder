$(() => {
  $(".dull-list-group-thruput[id]").on("click", ".list-group-item:not(.disabled)", function(e) {
    e.preventDefault();

    let $parent = $(this).closest(".dull-list-group-thruput");
    console.log($parent);

    if (!$parent.data("multiple")) {
      $parent.children(".list-group-item.active").removeClass("active");
    }

    $(this).toggleClass("active")
      .trigger("change");
  });
});

// input
let listGroupInputBinding = new Shiny.InputBinding();

$.extend(listGroupInputBinding, {
  find: (scope) => $(scope).find(".dull-list-group-thruput[id]"),

  getId: (el) => el.id,

  getValue: (el) => {
    return $(el)
      .children(".list-group-item.active:not(.disabled)")
      .map((index, item) => $(item).data("value"))
      .get();
  },

  getState: (el, data) => ({ value: this.getValue(el) }),

  subscribe: (el, callback) => {
    $(el).on("change.listGroupInputBinding", (e) => callback());
  },

  unsubscribe: (el) => $(el).off(".listGroupInputBinding")
});

Shiny.inputBindings.register(listGroupInputBinding, "dull.listGroupInput");

// output
let listGroupOutputBinding = new Shiny.OutputBinding();

$.extend(listGroupOutputBinding, {
  find: (scope) => $(scope).find(".dull-list-group-thruput[id]"),

  getId: (el) => el.id,

  renderValue: (el, data) => {
    if (data.items) {
      let items = data.items.join("\n");

      Shiny.renderContent(el, items);
    }
  }
});

Shiny.outputBindings.register(listGroupOutputBinding, "dull.listGroupOutput");

$(() => {
  $(".dull-list-group-thruput[id]").on("click", ".list-group-item:not(.disabled)", (e) => {
    e.preventDefault();

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
    $(el)
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
    console.log(data);
    $(el).append(
      $.map(data.values, (val, i) => $("<a class='list-group-item'>" + val + "</a>"))
    );
  }
});

Shiny.outputBindings.register(listGroupOutputBinding, "dull.listGroupOutput");

// input
export let listGroupInputBinding = new Shiny.InputBinding();

// $(() => {
//   $(".yonder-list-group[id]").on("click", ".list-group-item-action", (e) => {
//     e.target.classList.toggle("active");
//     return true;
//   });
// });

$.extend(listGroupInputBinding, {
  find: (scope) => $(scope).find(".yonder-list-group[id]"),

  getId: (el) => el.id,

  getValue: (el) => {
    return Array.prototype.map.call(
      el.querySelectorAll(".list-group-item-action.active:not(.disabled)"),
      (child) => child.getAttribute("data-value")
    );
  },

  getState: function(el, data) {
    return { value: this.getValue(el) };
  },

  subscribe: (el, callback) => {
    if (el.getAttribute("data-multiple") === "true") {
      $(el).on("click", ".list-group-item-action", (e) => {
        e.currentTarget.classList.toggle("active");
        callback();
      });
    } else {
      $(el).on("click", ".list-group-item-action", (e) => {
        el.querySelectorAll(".list-group-item-action.active").forEach(li => {
          li.classList.remove("active");
        });
        e.currentTarget.classList.add("active");
        callback();
      });
    }
  },

  unsubscribe: (el) => $(el).off(".listGroupInputBinding")
});

Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

export let listGroupInputBinding = new Shiny.InputBinding();

$.extend(listGroupInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-list-group[id]"),
  initialize: (el) => {
    let $el = $(el);

    $el.on("click", ".list-group-item-action:not(.active):not(.disabled)", (e) => {
      el.querySelectorAll(".active").forEach(item => {
        item.classList.remove("active");
      });

      e.currentTarget.classList.add("active");
    });

    $el.on("click", ".list-group-item-action.active:not(.disabled)", (e) => {
      e.currentTarget.classList.remove("active");
    });
  },
  getValue: (el) => {
    let items = el.querySelectorAll(".list-group-item-action.active:not(.disabled)");

    if (items.length === 0) {
      return null;
    }

    return Array.prototype.slice.call(items).map(i => i.value);
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", e => callback());
  },
  unsubcribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.querySelectorAll(".list-group-item").forEach(item => {
        el.removeChild(item);
      });
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelectorAll(".list-group-item").forEach(item => {
          item.classList.remove("disabled");
        });
      } else {
        el.querySelectorAll(".list-group-item").forEach(item => {
          if (enable.indexOf(item.value) > -1) {
            item.classList.remove("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        el.querySelectorAll(".list-group-item").forEach(item => {
          item.classList.add("disabled");
        });
      } else {
        el.querySelectorAll(".list-group-item").forEach(item => {
          if (disable.indexOf(item.value) > -1) {
            item.classList.add("disabled");
          }
        });
      }
    }
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

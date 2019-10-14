import { actionListener } from "./actions.js";

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

    actionListener(el, ".list-group-item:not(.disabled)", "click");
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

    $el.on("click.yonder", (e) => callback());
    $el.on("listgroup.select.yonder", (e) => callback());
  },
  unsubcribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.querySelectorAll(".list-group-item").forEach(item => {
        el.removeChild(item);
      });
      el.insertAdjacentHTML("afterbegin", msg.content);
    }

    if (msg.selected) {
      if (msg.selected !== true) {
        el.querySelectorAll(".list-group-item.active").forEach(item => {
          item.classList.remove("active");
        });
      }

      el.querySelectorAll(".list-group-item").forEach(item => {
        if (msg.selected === true || msg.selected.indexOf(item.value) > -1) {
          item.classList.add("active");
        }
      });

      $(el).trigger("listgroup.select.yonder");
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

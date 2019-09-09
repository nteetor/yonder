import { actionListener } from "./actions.js";

export let menuInputBinding = new Shiny.InputBinding();

$.extend(menuInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-menu[id]"),
  initialize: (el) => {
    let $el = $(el);

    $el.on("click", ".dropdown-item:not(.disabled)", (e) => {
      let active = el.querySelector(".dropdown-item.active");
      if (active !== null) {
        active.classList.remove("active");
      }
      e.currentTarget.classList.add("active");
    });

    $el.on("nav.reset", (e) => {
      let active = el.querySelector(".dropdown-item.active");
      if (active !== null) {
        active.classList.remove("active");
      }
    });

    actionListener(el, ".dropdown-item", "click");
  },
  getValue: (el) => {
    let active = el.querySelector(".dropdown-item.active:not(.disabled)");

    if (active === null) {
      return null;
    }

    return active.value;
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", (e) => callback());
    $el.on("menu.select.yonder", (e) => callback());
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.querySelector(".dropdown-menu").innerHTML = msg.content;
    }

    if (msg.label) {
      let toggle = el.querySelector(".dropdown-toggle");
      toggle.innerHTML = msg.label;
    }

    if (msg.selected) {
      el.querySelectorAll(".dropdown-item").forEach(item => {
        if (msg.selected.indexOf(item.value) > -1) {
          item.classList.add("active");
        } else {
          item.classList.remove("active");
        }
      });

      $(el).trigger("menu.select.yonder");
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelector(".dropdown-toggle").classList.remove("disabled");
      } else {
        el.querySelectorAll(".dropdown-item").forEach(item => {
          if (enable.indexOf(item.value) > -1) {
            item.classList.remove("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        el.querySelector(".dropdown-toggle").classList.add("disabled");
      } else {
        el.querySelectorAll(".dropdown-item").forEach(item => {
          if (disable.indexOf(item.value) > -1) {
            item.classList.add("disabled");
          }
        });
      }
    }
  }
});

Shiny.inputBindings.register(menuInputBinding, "yonder.menuInput");

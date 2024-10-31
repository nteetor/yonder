export let radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  Selector: {
    SELF: ".yonder-radiobar[id]",
    SELECTED: "input:checked:not(:disabled)"
  },
  Events: [
    { type: "click" },
    { type: "change" }
  ],
  find: (scope) => scope.querySelectorAll(".yonder-radiobar[id]"),
  getValue: (el) => {
    let radios = el.querySelectorAll("input:checked:not(:disabled)");

    if (radios.length === 0) {
      return null;
    }

    return Array.prototype.slice.call(radios).map(r => r.value);
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", e => callback());
    $el.on("change.yonder", e => callback());
    $el.on("radiobar.select.yonder", e => callback());
  },
  unsubscribe: (el) => {
    $(el).off(".yonder");
  },
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.innerHTML = msg.content;
    }

    if (msg.selected) {
      el.querySelectorAll("input").forEach(input => {
        if (msg.selected.indexOf(input.value) > -1) {
          input.checked = true;
          input.parentNode.classList.add("active");
        } else {
          input.checked = false;
          input.parentNode.classList.remove("active");
        }
      });

      $(el).trigger("radiobar.select.yonder");
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelectorAll(".btn").forEach(btn => {
          btn.classList.remove("disabled");
          btn.children[0].removeAttribute("disabled");
        });
      } else {
        el.querySelectorAll("input").forEach(input => {
          if (enable.indexOf(input.value) > -1) {
            input.parentNode.classList.remove("disabled");
            input.removeAttribute("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        el.querySelectorAll(".btn").forEach(btn => {
          btn.classList.add("disabled");
          btn.children[0].setAttribute("disabled", "");
        });
      } else {
        el.querySelectorAll("input").forEach(input => {
          if (disable.indexOf(input.value) > -1) {
            input.parentNode.classList.add("disabled");
            input.setAttribute("disabled", "");
          }
        });
      }
    }
  }
});

Shiny.inputBindings.register(radiobarInputBinding, "yonder.radiobarInput");

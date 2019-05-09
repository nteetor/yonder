export let checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-checkbar[id]"),
  getValue: (el) => {
    let checked = el.querySelectorAll("input:checked:not(:disabled)");

    if (checked.length === 0) {
      return null;
    }

    return Array.prototype.map.call(checked, c => c.value);
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", e => callback());
    $el.on("change.yonder", e => callback());
    $el.on("checkbar.select.yonder", (e) => callback());
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.querySelectorAll(".btn").forEach(btn => {
        el.removeChild(btn);
      });
      el.insertAdjacentHTML("afterbegin", msg.content);
    }

    if (msg.selected) {
      if (msg.selected !== true) {
        el.querySelectorAll("input:checked").forEach(input => {
          input.checked = false;
          input.parentNode.classList.remove("active");
        });
      }

      el.querySelectorAll("input").forEach(input => {
        if (msg.selected === true || msg.selected.indexOf(input.value) > -1) {
          input.checked = true;
          input.parentNode.classList.add("active");
        }
      });

      $(el).trigger("checkbar.select.yonder");
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelectorAll(".btn").forEach(btn => {
          btn.classList.remove("disabled");
          btn.children[0].removeAttribute("disabled");
        });
      } else {
        el.querySelectorAll(".btn").forEach(btn => {
          if (enable.indexOf(btn.value) > -1) {
            btn.classList.remove("disabled");
            btn.children[0].removeAttribute("disabled");
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
        el.querySelectorAll(".btn").forEach(btn => {
          if (disable.indexOf(btn.value) > -1) {
            btn.classList.add("disabled");
            btn.children[0].setAttribute("disabled", "");
          }
        });
      }
    }
  }
});

Shiny.inputBindings.register(checkbarInputBinding, "yonder.checkbarInput");

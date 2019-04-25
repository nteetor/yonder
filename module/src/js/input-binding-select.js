export let selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  find: (scope) => {
    return scope.querySelectorAll(".yonder-select[id]");
  },
  getValue: (el) => {
    let selected = el.querySelectorAll("option:checked:not(:disabled");

    if (selected.length === 0) {
      return null;
    }

    return Array.prototype.slice.call(selected).map(o => o.value);
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("change.yonder", e => callback());
  },
  unsubscribe: (el) => {
    $(el).off(".yonder");
  },
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.querySelector(".custom-select").innerHTML = msg.content;
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelector(".custom-select").classList.remove("disabled");
      } else {
        el.querySelectorAll("option").forEach(opt => {
          if (enable.indexOf(opt.value) > -1) {
            opt.removeAttribute("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        el.querySelector(".custom-select").classList.add("disabled");
      } else {
        el.querySelectorAll("option").forEach(opt => {
          if (disable.indexOf(opt.value) > -1) {
            opt.setAttribute("disabled", "");
          }
        });
      }
    }

    if (msg.valid) {
      el.querySelector(".custom-select").classList.add("is-valid");
      el.querySelector(".valid-feedback").innerHTML = msg.valid;
    }

    if (msg.invalid) {
      el.querySelector(".custom-select").classList.add("is-invalid");
      el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
    }

    if (!msg.valid && !msg.invalid) {
      let select = el.querySelector(".custom-select");
      select.classList.remove("is-valid");
      select.classList.remove("is-invalid");

      el.querySelector(".valid-feedback").innerHTML = "";
      el.querySelector(".invalid-feedback").innerHTML = "";
    }
  }
});

Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");

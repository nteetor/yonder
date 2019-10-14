import { actionListener } from "./actions.js";

export let checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-checkbox[id]"),
  getValue: (el) => {
    let checked = el.querySelectorAll("input:checked:not(:disabled)");

    if (checked.length === 0) {
      return null;
    }

    return Array.prototype.map.call(checked, c => c.value);
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("change.yonder", (e) => callback());
    $el.on("checkbox.select.yonder", (e) => callback());
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.querySelectorAll(".custom-checkbox").forEach(box => {
        el.removeChild(box);
      });

      el.insertAdjacentHTML("afterbegin", msg.content);
    }

    if (msg.selected) {
      el.querySelectorAll("input:checked").forEach(input => {
        input.checked = false;
      });

      el.querySelectorAll("input").forEach(input => {
        if (msg.selected === true || msg.selected.indexOf(input.value) > -1) {
          input.checked = true;
        }
      });

      $(el).trigger("checkbox.select.yonder");
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelectorAll("input").forEach(input => {
          input.removeAttribute("disabled");
        });
      } else {
        el.querySelectorAll("input").forEach(input => {
          if (enable.indexOf(input.value) > -1) {
            input.removeAttribute("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        el.querySelectorAll("input").forEach(input => {
          input.setAttribute("disabled", "");
        });
      } else {
        el.querySelectorAll("input").forEach(input => {
          if (disable.indexOf(input.value) > -1) {
            input.setAttribute("disabled", "");
          }
        });
      }
    }

    if (msg.valid) {
      el.querySelector(".invalid-feedback").innerHTML = "";
      el.querySelector(".valid-feedback").innerHTML = msg.valid;
      el.querySelectorAll("input").forEach(input => {
        input.classList.remove("is-invalid");
        input.classList.add("is-valid");
      });
    }

    if (msg.invalid) {
      el.querySelector(".valid-feedback").innerHTML = "";
      el.querySelector(".inavlid-feedback").innerHTML = msg.invalid;
      el.querySelectorAll("input").forEach(input => {
        input.classList.remove("is-valid");
        input.classList.add("is-invalid");
      });
    }

    if (!msg.valid && !msg.invalid) {
      el.querySelector(".valid-feedback").innerHTML = "";
      el.querySelector(".invalid-feedback").innerHTML = "";
      el.querySelectorAll("input").forEach(input => {
        input.classList.remove("is-valid");
        input.classList.remove("is-invalid");
      });
    }
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");

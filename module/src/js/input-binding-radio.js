export let radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  find: (scope) => {
    return scope.querySelectorAll(".yonder-radio[id]");
  },
  getValue: (el) => {
    let radios = el.querySelectorAll(".custom-radio > input:checked:not(:disabled)");

    if (radios.length === 0) {
      return null;
    }

    return Array.prototype.slice.call(radios).map(r => r.value);
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
      el.querySelectorAll(".custom-radio").forEach((radio) => {
        el.removeChild(radio);
      });

      el.insertAdjacentHTML("afterbegin", msg.content);
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelectorAll(".custom-radio > input").forEach(input => {
          input.removeAttribute("disabled");
        });
      } else {
        el.querySelectorAll(".custom-radio > input").forEach(input => {
          if (enable.indexOf(input.value) > -1) {
            input.removeAttribute("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        el.querySelectorAll(".custom-radio > input").forEach(input => {
          input.setAttribute("disabled", "");
        });
      } else {
        el.querySelectorAll(".custom-radio > input").forEach(input => {
          if (disable.indexOf(input.value)> -1) {
            input.setAttribute("disabled", "");
          }
        });
      }
    }

    if (msg.valid) {
      el.querySelector(".valid-feedback").innerHTML = msg.valid;
      el.querySelectorAll(".custom-control-input").forEach(radio => {
        radio.classList.add("is-valid");
      });
    }

    if (msg.invalid) {
      el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
      el.querySelectorAll(".custom-control-input").forEach(radio => {
        radio.classList.add("is-invalid");
      });
    }

    if (!msg.valid && !msg.invalid) {
      el.querySelector(".valid-feedback").innerHTML = "";
      el.querySelector(".invalid-feedback").innerHTML = "";
      el.querySelectorAll(".custom-control-input").forEach(radio => {
        radio.classList.remove("is-valid");
        radio.classList.remove("is-invalid");
      });
    }
  }
});

Shiny.inputBindings.register(radioInputBinding, "yonder.radioInput");

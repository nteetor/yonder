export let groupTextInputBinding = new Shiny.InputBinding();

$.extend(groupTextInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-group-text[id]"),
  getValue: (el) => {
    let inputs = el.querySelectorAll(".input-group-prepend .input-group-text, input, .input-group-append .input-group-text");

    return Array.prototype.slice.call(inputs)
      .map(i => /^(DIV|SPAN)$/.test(i.tagName) ? i.innerText : (i.value || null))
      .filter(value => value !== null);
  },
  getType: () => "yonder.group",
  subscribe: (el, callback) => {
    let $el = $(el);

    if (el.querySelectorAll(".btn").length > 0) {
      $el.on("click", ".dropdown-item", e => callback());
      $el.on("click", ".btn:not(.dropdown-toggle", e => callback());
    } else {
      $el.on("input", e => callback(true));
      $el.on("change", e => callback(true));
    }
  },
  receiveMessage: (el, msg) => {
    let input = el.querySelector("input");

    if (msg.value) {
      input.value = msg.values;
    }

    if (msg.enable) {
      input.removeAttribute("disabled");
    }

    if (msg.disable) {
      input.setAttribute("disabled", "");
    }

    if (msg.valid) {
      el.querySelector("valid-feedback").innerHTML = msg.valid;

      input.classList.remove("is-invalid");
      input.classList.add("is-valid");
    }

    if (msg.invalid) {
      el.querySelector("invalid-feedback").innerHTML = msg.invalid;

      input.classList.remove("is-valid");
      input.classList.add("is-invalid");
    }

    if (!msg.valid && !msg.invalid) {
      input.classList.remove("is-valid");
      input.classList.remove("is-invalid");

      el.querySelector("invalid-feedback").innerHTML = "";
      el.querySelector("valid-feedback").innerHTML = "";
    }
  }
});

Shiny.inputBindings.register(groupTextInputBinding, "yonder.groupTextInput");

export let groupSelectInputBinding = new Shiny.InputBinding();

$.extend(groupSelectInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-group-select[id]"),
  getValue: (el) => {
    let inputs = el.querySelectorAll(".input-group-prepend .input-group-text, input, .input-group-append .input-group-text");

    return Array.prototype.slice.call(inputs)
      .map(i => /^(DIV|SPAN)$/.test(i.tagName) ? i.innerText : (i.value || null))
      .filter(value => value !== null);
  },
  getType: () => "yonder.group",
  subscribe: (el, callback) => {
    let $el = $(el);

    if (el.querySelectorAll(".btn").length > 0) {
      $el.on("click", ".dropdown-item", e => callback());
      $el.on("click", ".btn:not(.dropdown-toggle", e => callback());
    } else {
      $el.on("change", e => callback(true));
    }
  },
  receiveMessage: (el, msg) => {
    let select = el.querySelector("select");

    if (msg.content) {
      select.innerHTML = msg.content;
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        select.removeAttribute("disabled");
      } else {
        select.querySelectorAll("option").forEach(option => {
          option.removeAttribute("disabled");
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable) {
        select.setAttribute("disabled", "");
      } else {
        select.querySelectorAll("option").forEach(option => {
          option.setAttribute("disabled", "");
        });
      }
    }

    if (msg.valid) {
      el.querySelector("valid-feedback").innerHTML = msg.valid;

      select.classList.remove("is-invalid");
      select.classList.add("is-valid");
    }

    if (msg.invalid) {
      el.querySelector("invalid-feedback").innerHTML = msg.invalid;

      select.classList.remove("is-valid");
      select.classList.add("is-invalid");
    }

    if (!msg.valid && !msg.invalid) {
      select.classList.remove("is-valid");
      select.classList.remove("is-invalid");

      el.querySelector("invalid-feedback").innerHTML = "";
      el.querySelector("valid-feedback").innerHTML = "";
    }

  }
});

Shiny.inputBindings.register(groupSelectInputBinding, "yonder.groupSelectInputBinding");

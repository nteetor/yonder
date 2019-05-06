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

    if (msg.selected) {
      el.querySelectorAll("option").forEach(option => {
        if (msg.selected === true || msg.selected.indexOf(option.value) > -1) {
          option.setAttribute("selected", "");
        }
      });
      $(el).trigger("change");
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
      $el.on("change", e => callback());
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

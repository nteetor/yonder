export let textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-textual[id]"),
  getValue: (el) => {
    let input = el.children[0];

    if (input.value === "") {
      return null;
    }

    return input.type === "number" ? Number(input.value) : input.value;
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("change.yonder", (e) => callback(true));
    $el.on("input.yonder", (e) => callback(true));
    $el.on("textual.value.yonder", (e) => callback(true));
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  getRatePolicy: () => ({ policy: "debounce", delay: 250 }),
  receiveMessage: (el, msg) => {
    if (msg.value !== null) {
      el.querySelector("input").value = msg.value;
      $(el).trigger("textual.value.yonder");
    }

    if (msg.enable) {
      el.children[0].removeAttribute("disabled");
    }

    if (msg.disable) {
      el.children[0].setAttribute("disabled", "");
    }

    let input = el.querySelector("input");

    if (msg.valid) {
      el.querySelector(".valid-feedback").innerHTML = msg.valid;
      input.classList.remove("is-invalid");
      input.classList.add("is-valid");
    }

    if (msg.invalid) {
      el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
      input.classList.remove("is-valid");
      input.classList.add("is-invalid");
    }

    if (!msg.valid && !msg.invalid) {
      el.querySelector(".valid-feedback").innerHTML = "";
      el.querySelector(".invalid-feedback").innerHTML = "";
      input.classList.remove("is-valid");
      input.classList.remove("is-invalid");
    }
  }
});

Shiny.inputBindings.register(textualInputBinding, "yonder.textualInput");

export let groupTextInputBinding = new Shiny.InputBinding();

$.extend(groupTextInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-group-text[id]"),
  getValue: (el) => {
    let inputs = el.querySelectorAll(".input-group-prepend .input-group-text, input, .input-group-append .input-group-text");

    return Array.prototype.slice.call(inputs)
      .map(i => /^(DIV|SPAN)$/.test(i.tagName) ? i.innerText : (i.value || null))
      .filter(value => value !== null);
  },
  getType: () => "yonder.group.text",
  getRatePolicy: (el) => ({ policy: "debounce", delay: 250 }),
  subscribe: (el, callback) => {
    let $el = $(el);

    if (el.querySelectorAll(".btn").length > 0) {
      $el.on("click.yonder", ".dropdown-item", (e) => callback());
      $el.on("click.yonder", ".btn:not(.dropdown-toggle", (e) => callback());
    } else {
      $el.on("input.yonder", (e) => callback(true));
      $el.on("change.yonder", (e) => callback(true));
      $el.on("textual.value.yonder", (e) => callback());
    }
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    let input = el.querySelector("input");

    if (msg.value) {
      input.value = msg.value;
      $(el).trigger("textual.value.yonder");
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

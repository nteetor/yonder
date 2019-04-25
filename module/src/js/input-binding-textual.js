export let textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-textual[id]"),
  getValue: (el) => {
    let input = el.children[0];
    return input.type === "number" ? Number(input.value) : input.value;
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("change.yonder", e => callback(true));
    $el.on("input.yonder", e => callback(true));
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  getRatePolicy: () => ({ policy: "debounce", delay: 250 }),
  receiveMessage: (el, msg) => {
    if (msg.value !== null) {
      el.querySelector("input").value = msg.value;
    }

    if (msg.enable) {
      el.children[0].removeAattribute("disabled");
    }

    if (msg.disable) {
      el.children[0].setAttribute("disabled", "");
    }

    if (msg.valid) {
      el.querySelector(".valid-feedback").innerHTML = msg.valid;
      el.classList.remove("is-invalid");
      el.classList.add("is-valid");
    }

    if (msg.invalid) {
      el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
      el.classList.remove("is-valid");
      el.classList.add("is-invalid");
    }

    if (!msg.valid && !msg.invalid) {
      el.querySelector(".valid-feedback").innerHTML = "";
      el.querySelector(".invalid-feedback").innerHTML = "";
      el.children[0].classList.remove("is-valid");
      el.children[0].classList.remove("is-invalid");
    }
  }
});

Shiny.inputBindings.register(textualInputBinding, "yonder.textualInput");

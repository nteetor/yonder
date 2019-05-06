export let linkInputBinding = new Shiny.InputBinding();

$.extend(linkInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-link[id]"),
  initialize: (el) => {
    $(el).on("click", e => el.value = +el.value + 1);
    el.value = 0;
  },
  getValue: (el) => +el.value > 0 ? +el.value : null,
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", e => callback());
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, data) => {
    if (data.content) {
      el.innerHTML = data.content;
    }

    if (data.enable) {
      el.classList.remove("disabled");
      el.removeAttribute("disabled");
    }

    if (data.disable) {
      el.classList.add("disabled");
      el.setAttribute("disabled", "");
    }
  }
});

Shiny.inputBindings.register(linkInputBinding, "yonder.linkInput");

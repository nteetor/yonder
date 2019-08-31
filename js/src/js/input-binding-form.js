export let formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-form[id]"),
  initialize: (el) => {
    let $document = $(document);
    let $el = $(el);

    let store = {};
    let value = null;

    el.querySelectorAll(".yonder-form-submit").forEach(s => {
      s.setAttribute("type", "submit");
    });

    $document.on("shiny:inputchanged.yonder", (e) => {
      if (!e.el || e.priority === "event") {
        return;
      }

      if (e.el.id === el.id) {
        Shiny.onInputChange(el.id, value, { priority: "event" });
        e.preventDefault();
        return;
      }

      if (el.contains(e.el)) {
        store[e.name] = e.value;
        e.preventDefault();
      }
    });

    $el.on("click.yonder", ".yonder-form-submit", (e) => {
      value = e.currentTarget.value;
    });

    $el.on("submit.yonder", (e, v) => {
      e.preventDefault();

      if (v !== undefined) {
        value = v;
      }

      Object.keys(store).forEach(key => {
        Shiny.onInputChange(key, store[key], { priority: "event" });
      });
    });
  },
  getValue: (el) => null,
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("submit.yonder", (e) => callback());
  },
  unsubscribe: (el) => {
    $(el).off(".yonder");
    $(document).off("shiny:inputchanged.yonder");
  },
  receiveMessage: (el, msg) => {
    if (msg.submit !== undefined && msg.submit !== null) {
      $(el).trigger("submit.yonder", msg.submit);
    }
  }
});

Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

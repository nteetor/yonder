export let formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-form[id]"),
  initialize: (el) => {
    let $el = $(el);

    let store = {};
    let value = null;

    el.querySelectorAll(".yonder-form-submit").forEach(s => {
      s.setAttribute("type", "submit");
    });

    $el.on("shiny:inputchanged.yonder", ".shiny-bound-input", (e) => {
      if (e.priority === "event") {
        return;
      }

      store[e.name] = e.value;
      e.preventDefault();
    });

    $el.on("click.yonder", ".yonder-form-submit", (e) => {
      Object.keys(store).forEach(key => {
        Shiny.onInputChange(key, store[key], { priority: "event" });
      });

      Shiny.onInputChange(el.id, e.currentTarget.value, { priority: "event" });
    });
  },
  getValue: (el) => null,
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("submit.yonder", (e) =>  callback());
  },
  unsubscribe: (el) => {
    $(el).off(".yonder");
  }
});

Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

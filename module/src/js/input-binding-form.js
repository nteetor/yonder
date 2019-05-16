export let formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-form[id]"),
  initialize: (el) => {
    let $document = $(document);
    let $el = $(el);
    let store = {};

    $document.on("shiny:inputchanged", (e) => {
      if (e.priority !== "event" &&
          e.el && el.querySelector(`#${ e.el.id }`) !== null) {
        store[e.name] = e.value;
        e.preventDefault();
      }
    });

    $el.on("submit", (e) => {
      Object.keys(store).forEach(key => {
        Shiny.onInputChange(key, store[key], { priority: "event" });
      });
    });
  },
  getType: () => "yonder.form",
  getValue: (el) => null,
  // return { force: Date.now(), value: this._VALUES[el.id] };
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("submit", (e) => callback());
  },
  unsubscribe: (el) => $(el).off("yonder")
});

Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

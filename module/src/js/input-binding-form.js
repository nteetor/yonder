export let formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  Events: [
    {
      type: "submit",
      callback: el => {
        let submit = el.querySelector("button[data-type='submit']");

        if (submit === null) {
          return;
        }

        submit.setAttribute("data-value", +submit.getAttribute("data-value") + 1);
      }
    }
  ],
  initialize: function(el) {
    let submit = el.querySelector("button[data-type='submit']");

    if (submit === null) {
      return;
    }

    submit.setAttribute("data-value", 0);
  },
  find: function(scope) {
    let forms = scope.querySelectorAll(".yonder-form[id]");

    return Array.prototype.slice.call(forms).filter(form => {
      return form.querySelector("button[data-type='submit']") !== null;
    });
  },
  getValue: function(el) {
    let submit = el.querySelector("button[data-type='submit']");

    return submit && +submit.getAttribute("data-value");
  }
});

Shiny.inputBindings.register(formInputBinding, "yonder.formInput");

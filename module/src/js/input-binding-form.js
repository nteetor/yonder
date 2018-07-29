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
    let $input = $(scope).find(".yonder-form[id]");

    if (!$input.children("button[data-type='submit']").length) {
      return null;
    }

    return $input;
  },
  getValue: function(el) {
    let submit = el.querySelector("button[data-type='submit']");

    if (submit === null) {
      return;
    }

    return +submit.getAttribute("data-value");
  }
});

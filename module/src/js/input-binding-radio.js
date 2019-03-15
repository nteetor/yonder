export let radioInputBinding = new Shiny.InputBinding();

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min)) + min; // The maximum is exclusive and the minimum is inclusive
}

$.extend(radioInputBinding, {
  Selector: {
    SELF: ".yonder-radio[id]",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".custom-radio").cloneNode(true);
    template.children[0].removeAttribute("id");
    template.children[0].removeAttribute("checked");
    template.children[1].removeAttribute("for");

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let id = `radio-${ getRandomInt(100, 1000) }-${ getRandomInt(100, 1000) }`;
      let child = template.cloneNode(true);

      child.children[1].innerHTML = choice;
      child.children[1].setAttribute("for", id);

      child.children[0].value = data.values[i];
      child.children[0].setAttribute("id", id);

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.children[0].setAttribute("checked", "");
      }

      el.appendChild(child);
    });
  },
  _select: (el, data) => {
    el.querySelectorAll(".custom-control-input").forEach(child => {
      let value = child.value;

      if (data.reset) {
        child.removeAttribute("checked");
      }

      let match = data.fixed ? data.pattern.indexOf(value) > -1 :
          RegExp(data.pattern, "i").test(value);

      if (match !== data.invert) {
        child.setAttribute("checked", "");
      }
    });
  },
  _enable: (el, data) => {
    el.querySelectorAll(".custom-control-input").forEach(input => {
      let enable = !data.values.length || data.values.indexOf(input.value) > -1;

      if (enable !== data.invert) {
        input.removeAttribute("disabled");
      }
    });
  },
  _disable: (el, data) => {
    el.querySelectorAll(".custom-control-input").forEach(input => {
      let disable = !data.values.length || data.values.indexOf(input.value) > -1;

      if (data.reset) {
        input.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        input.setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(radioInputBinding, "yonder.radioInput");

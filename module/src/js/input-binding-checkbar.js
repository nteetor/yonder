export let checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  Selector: {
    SELF: ".yonder-checkbar",
    SELECTED: "input:checked"
  },
  Events: [
    { type: "change", selector: ".btn" }
  ],
  _value: (el, newValue, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`input[value="${ currentValue }"]`);
      if (target !== null) {
        target.value = newValue;
      }
    } else {
      let possibles = el.querySelectorAll("input");
      if (index < possibles.length) {
        possibles[index].value = newValue;
      }
    }
  },
  _choice: (el, newLabel, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`input[value="${ currentValue }"]`);

      if (target !== null) {
        let btn = target.parentNode;
        let input = target.cloneNode();

        btn.innerHTML = "";
        btn.appendChild(input);
        btn.insertAdjacentText("beforeend", newLabel);
      }
    } else {
      let possibles = el.querySelectorAll("input");

      if (index < possibles.length) {
        let btn = possibles[index].parentNode;
        let input = possibles[index].cloneNode();

        btn.innerHTML = "";
        btn.appendChild(input);
        btn.insertAdjacentText("beforeend", newLabel);
      }
    }
  },
  _select: (el, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`input[value="${ currentValue }"]`);

      if (target !== null) {
        target.parentNode.classList.add("active");
        target.setAttribute("selected", "");
      }
    }
  },
  _clear: (el) => {
    el.querySelectorAll(".btn").forEach(btn => {
      btn.classList.remove("active");
      btn.children[0].setAttribute("selected", "");
    });
  },
  _enable: function(el, data) {
    let values = data.values;
    el.querySelectorAll(".btn").forEach(btn => {
      let enable = !values.length || values.indexOf(btn.children[0].value) > -1;

      if (enable !== data.invert) {
        btn.classList.remove("disabled");
        btn.children[0].removeAttribute("disabled");
      }
    });
  },
  _disable: function(el, data) {
    let values = data.values;
    el.querySelectorAll(".btn").forEach(btn => {
      let disable = !values.length || values.indexOf(btn.children[0].value) > -1;

      if (data.reset) {
        btn.classList.remove("disabled");
        btn.children[0].removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        btn.classList.add("disabled");
        btn.children[0].setAttribute("disabled", "");
      }
    });
  }
});

Shiny.inputBindings.register(checkbarInputBinding, "yonder.checkbarInput");

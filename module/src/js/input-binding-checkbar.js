export let checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  Selector: {
    SELF: ".yonder-checkbar",
    SELECTED: "input:checked"
  },
  Events: [
    { type: "change", selector: ".btn" }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".btn").cloneNode(true);
    template.classList.remove("active");
    template.classList.remove("disabled");
    template.children[0].removeAttribute("disabled");

    let input = template.children[0].cloneNode();
    template.innerHTML = "";
    template.appendChild(input);

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode(true);
      child.insertAdjacentHTML("beforeend", choice);
      child.children[0].value = data.values[i];

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.classList.add("active");
        child.children[0].checked = true;
      }

      el.appendChild(child);
    });
  },
  _select: function(el, data) {
    el.querySelectAll(".btn").forEach(child => {
      let value = child.children[0].value;

      if (data.reset) {
        child.classList.remove("active");
        child.children[0].checked = false;
      }

      let match = data.fixed ? data.pattern.indexOf(value) > -1 :
          RegExp(data.pattern, "i").test(value);

      if (match !== data.invert) {
        child.classList.add("active");
        child.children[0].checked = true;
      }
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

export let chipInputBinding = new Shiny.InputBinding();

$.extend(chipInputBinding, {
  selectorActive: ".active",
  selectorToggle: "input[data-toggle='dropdown']",

  find: (scope) => scope.querySelectorAll(".yonder-chip[id]"),
  initialize: (el) => {
    let $el = $(el);
    let $toggle = $(el.querySelector(chipInputBinding.selectorToggle));

    $el.on("input", (e) => {
      let value = $toggle[0].value;

      chipInputBinding._filter(el, value);

      if (chipInputBinding._visible(el).length === 0) {
        $toggle.dropdown("hide");
      } else {
        $toggle.dropdown("show");
      }
    });

    $el.on("input change", (e) => {
      $toggle.dropdown("update");
    });

    $el.on("hide.bs.dropdown", (e) => {
      if (el.querySelector("input:focus") === null) {
        el.querySelector("input").value = "";
        chipInputBinding._filter(el, "");
      }
    });

    $el.on("click", ".dropdown-item", (e) => {
      e.stopPropagation();

      chipInputBinding._add(el, e.currentTarget.value);
      $toggle[0].focus();
    });

    $el.on("click", ".chip", (e) => {
      chipInputBinding._remove(el, e.currentTarget.value);
    });

    let max = +el.getAttribute("data-max");

    if (max !== -1 && chipInputBinding._selected(el).length >= max) {
      chipInputBinding._disable(el);
    }
  },
  getValue: (el) => {
    let selected = el.querySelectorAll(".active");

    if (selected.length === 0) {
      return null;
    }

    return Array.prototype.map.call(selected, s => s.value);
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click", ".dropdown-item,.chip", (e) => callback());
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.items && msg.chips) {
      el.querySelector(".dropdown-menu").innerHTML = msg.items;
      el.querySelector(".chips").innerHTML = msg.chips;
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        chipInputBinding._enable(el);
        // el.querySelector("input").removeAttribute("disabled");
      } else {
        el.querySelectorAll(".dropdown-item,.chip").forEach(item => {
          if (enable.indexOf(item.value) > -1) {
            item.removeAttribute("disabled");
            item.classList.remove("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        chipInputBinding._disable(el);
        // el.querySelector("input").setAttribute("disabled", "");
      } else {
        el.querySelectorAll(".dropdown-item,.chip").forEach(item => {
          if (disable.indexOf(item.value) > -1) {
            item.setAttribute("disabled", "");
            item.classList.add("disabled");
          }
        });
      }
    }
  },

  _enable: (el) => {
    let input = el.querySelector("input");
    input.removeAttribute("disabled");
    input.classList.remove("disabled");
  },
  _disable: (el) => {
    let input = el.querySelector("input");
    input.setAttribute("disabled", "");
    input.classList.add("disabled");
  },

  _filter: (el, value) => {
    value = value.toLowerCase();

    el.querySelectorAll(".dropdown-item").forEach(item => {
      let match = item.innerText.toLowerCase().indexOf(value) !== -1;

      if (match) {
        item.classList.remove("filtered");
      } else {
        item.classList.add("filtered");
      }
    });
  },
  _visible: (el) => {
    return el.querySelectorAll(":not(.selected),:not(.filtered)");
  },
  _selected: (el) => {
    return el.querySelectorAll(".selected");
  },
  _items: (el, value) => {
    return Array.prototype.filter.call(
      el.querySelectorAll(".dropdown-item"),
      chip => chip.value === value
    );
  },
  _chips: (el, value) => {
    return Array.prototype.filter.call(
      el.querySelectorAll(".chip"),
      chip => chip.value === value
    );
  },

  _add: (el, value) => {
    let $toggle = $(el.querySelector(chipInputBinding.selectorToggle));

    chipInputBinding._items(el, value).forEach(item => {
      item.classList.add("selected");
    });

    let chips = el.querySelector(".chips");
    chipInputBinding._chips(el, value).forEach(chip => {
      chips.insertBefore(chips.removeChild(chip), chips.firstChild);
      chip.classList.add("active");
    });

    if (chipInputBinding._visible(el).length === 0) {
      $toggle.dropdown("hide");
    }

    let max = +el.getAttribute("data-max");

    if (max === -1 || chipInputBinding._selected(el).length < max) {
      $toggle.dropdown("update");
    } else {
      $toggle.dropdown("hide");
      chipInputBinding._disable(el);
    }
  },
  _remove: (el, value) => {
    let max = +el.getAttribute("data-max");

    chipInputBinding._chips(el, value).forEach(chip => {
      chip.classList.remove("active");
    });

    chipInputBinding._items(el, value).forEach(item => {
      item.classList.remove("selected");
    });

    if (max === -1 || chipInputBinding._selected(el).length < max) {
      chipInputBinding._enable(el);
    }
  }
});

Shiny.inputBindings.register(chipInputBinding, "yonder.chipInput");

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

      chipInputBinding.filterItems(el, value);

      if (chipInputBinding.visibleItems(el) === 0) {
        $toggle.dropdown("hide");
      } else {
        $toggle.dropdown("show");
      }
    });

    $el.on("input change", (e) => $toggle.dropdown("update"));

    $el.on("hide.bs.dropdown", (e) => {
      if (el.querySelector("input:focus") === null) {
        el.querySelector("input").value = "";
        chipInputBinding.filterItems(el, "");
      }
    });

    $el.on("click", ".dropdown-item", (e) => {
      e.stopPropagation();

      chipInputBinding.addChip(el, e.currentTarget.value);

      el.querySelector(chipInputBinding.selectorToggle).focus();
    });

    $el.on("click", ".chip", (e) => {
      chipInputBinding.removeChip(el, e.currentTarget.value);
    });

    let max = +el.getAttribute("data-max");

    if (max !== -1 && chipInputBinding.selectedItems(el) >= max) {
      chipInputBinding.disableToggle(el);
    }
  },

  receiveMessage: (el, msg) => {
    if (msg.items && msg.chips) {
      let menu = el.querySelector(".dropdown-menu");

      if (menu) {
        menu.innerHTML = msg.items;
      }

      let chips = el.querySelector(".chips");

      if (chips) {
        chips.innerHTML = msg.chips;
      }
    }

    if (msg.enable) {
      if (msg === true) {

      } else if () {
        el.querySelectorAll(".dropdown-item,.chip").forEach(item => {
          if (msg.enable.indexOf(item.value) > -1) {
            item.removeAttribute("disabled");
            item.classList.remove("disabled");
          }
        }
      }
    }
  },
  _disable: function(el, data) {
    el.querySelectorAll(".dropdown-item,.chip").forEach(item => {
      let disable = !data.values.length || data.values.indexOf(item.value)> -1;
      if (data.reset) {
        item.removeAttribute("disabled");
        item.classList.removeAttribute("disabled");
      }

      if (disable !== data.invert) {
        item.setAttribute("disabled", "");
        item.classList.add("disabled");
      }
    });
  }
  },

  enableToggle: (el) => {
    let input = el.querySelector("input");
    input.removeAttribute("disabled");
    input.classList.remove("disabled");
  },
  disableToggle: (el) => {
    let input = el.querySelector("input");
    input.setAttribute("disabled", "");
    input.classList.add("disabled");
  },

  filterItems: (el, value) => {
    el.querySelectorAll(".dropdown-item").forEach(item => {
      let match = item.innerText.toLowerCase().indexOf(value) !== -1;

      if (match) {
        item.classList.remove("filtered");
      } else {
        item.classList.add("filtered");
      }
    });
  },
  visibleItems: (el) => {
    return el.querySelectorAll(":not(.selected), :not(.filtered)").length;
  },
  selectedItems: (el) => {
    return el.querySelectorAll(".selected").length;
  },
  getItem: function(el, value) {
    return Array.prototype.filter.call(
      el.querySelectorAll(".dropdown-item"),
      chip => chip.value === value
    );
  },

  addChip: function(el, value) {
    this.getItem(el, value).forEach(item => item.classList.add("selected"));

    this.getChip(el, value).forEach(chip => chip.classList.add("active"));

    if (this.visibleItems(el) === 0) {
      $(el.querySelector(this.Selector.TOGGLE)).dropdown("hide");
    }

    let max = +el.getAttribute("data-max");

    if (max === -1 || this.selectedItems(el) < max) {
      $(el.querySelector(this.Selector.TOGGLE)).dropdown("update");
    } else {
      $(el.querySelector(this.Selector.TOGGLE)).dropdown("hide");
      this.disableToggle(el);
    }
  },
  removeChip: function(el, value) {
    let max = +el.getAttribute("data-max");

    this.getChip(el, value).forEach(chip => chip.classList.remove("active"));

    this.getItem(el, value).forEach(item => item.classList.remove("selected"));

    if (max === -1 || this.selectedItems(el) < max) {
      this.enableToggle(el);
    }
  },
  getChip: function(el, value) {
    return Array.prototype.filter.call(
      el.querySelectorAll(".chip"),
      chip => chip.value === value
    );
  },

  _update: function(el, data) {
    let itemTemplate = el.querySelector(".dropdown-item").cloneNode();
    itemTemplate.value = "";
    itemTemplate.innerText = "";
    itemTemplate.classList.remove("selected");
    itemTemplate.classList.remove("filtered");

    let chipTemplate = el.querySelector(".chip").cloneNode(true);
    chipTemplate.value = "";
    chipTemplate.children[0].innerHTML = "";
    chipTemplate.classList.remove("active");

    let menu = el.querySelector(".dropdown-menu");
    let chips = el.querySelector(".chips");

    menu.innerHTML = "";
    chips.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let item = itemTemplate.cloneNode();
      item.value = data.values[i];
      item.innerHTML = choice;

      let chip = chipTemplate.cloneNode(true);
      chip.value = data.values[i];
      chip.children[0].innerHTML = choice;

      if (data.selected.indexOf(data.values[i]) > -1) {
        item.classList.add("selected");
        chip.classList.add("active");
      }

      menu.appendChild(item);
      chips.appendChild(chip);
    });
  },
  _select: function(el, data) {
    el.querySelectorAll(".chip").forEach(item => {
      let value = item.value;

      if (data.reset) {
        this.removeChip(el, value);
      }

      let match = data.fixed ? data.pattern.indexOf(value) > -1 :
        RegExp(data.pattern, "i").test(value);

      if (match != data.invert) {
        this.addChip(el, value);
      }
    });
  }
});

Shiny.inputBindings.register(chipInputBinding, "yonder.chipInput");

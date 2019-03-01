export let chipInputBinding = new Shiny.InputBinding();

$.extend(chipInputBinding, {
  Selector: {
    SELF: ".yonder-chip",
    SELECTED: ".active",
    TOGGLE: "input[data-toggle='dropdown']"
  },
  Events: [
    {
      type: "input",
      callback: (el, event, self) => {
        let value = el.querySelector(self.Selector.TOGGLE).value;
        self.filterItems(el, value);

        if (self.visibleItems(el) === 0) {
          $(el.querySelector(self.Selector.TOGGLE)).dropdown("hide");
        } else {
          $(el.querySelector(self.Selector.TOGGLE)).dropdown("show");
        }
      }
    },
    {
      type: "input change",
      callback: (el, event, self) => {
        $(el.querySelector(self.Selector.TOGGLE)).dropdown("update");
      }
    },
    {
      type: "hide.bs.dropdown",
      callback: (el, event, self) => {
        if (el.querySelector("input:focus") === null) {
          el.querySelector("input").value = "";
          self.filterItems(el, "");
        }
      }
    },
    {
      type: "click",
      selector: ".dropdown-item",
      callback: (el, event, self) => {
        event.stopPropagation();

        self.addChip(el, event.currentTarget.value);

        el.querySelector(self.Selector.TOGGLE).focus();
      }
    },
    {
      type: "click",
      selector: ".chip",
      callback: (el, event, self) => {
        self.removeChip(el, event.currentTarget.value);
      }
    }
  ],

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

  addChip: function(el, value) {
    el.querySelector(`.dropdown-item[value="${ value }"]`).classList.add("selected");

    el.querySelectorAll(`.chip[value="${ value }"]`)
      .forEach(chip => chip.classList.add("active"));

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

    el.querySelector(`.chip[value="${ value }"]`).classList.remove("active");

    el.querySelectorAll(`.dropdown-item[value='${ value }']`)
      .forEach(item => item.classList.remove("selected"));

    if (max === -1 || this.selectedItems(el) < max) {
      this.enableToggle(el);
    }
  },

  initialize: function(el) {
    let max = +el.getAttribute("data-max");

    if (max !== -1 && this.selectedItems(el) >= max) {
      this.disableToggle(el);
    }
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

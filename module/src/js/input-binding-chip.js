export let chipInputBinding = new Shiny.InputBinding();

$.extend(chipInputBinding, {
  Selector: {
    SELF: ".yonder-chip",
    SELECTED: ".active"
  },
  Events: [
    {
      type: "input",
      callback: (el, event, self) => {
        let value = event.currentTarget.value;
        self.filterItems(el, value);

        if (self.visibleItems(el) === 0) {
          $(el.querySelector("input[data-toggle='dropdown']")).dropdown("hide");
        } else {
          $(el.querySelector("input[data-toggle='dropdown']")).dropdown("show");
        }
      }
    },
    {
      type: "input change",
      callback: (el, event, self) => {
        el.querySelector("input[data-toggle='dropdown']").dropdown("update");
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

        let item = event.currentTarget;
        let label = item.innerText;
        let value = item.value;

        let input = el.querySelector("input");
        let max = +el.getAttribute("data-max");

        item.classList.add("selected");

        el.querySelectorAll(`.chip[value="${ value }"]`)
          .forEach(chip => chip.classList.add("active"));

        if (self.visibleItems(el) === 0) {
          input.dropdown("hide");
        }

        input.focus();

        if (max === -1 || self.selectedItems(el) < max) {
          self.enableToggle(el);
        }
      }
    },
    {
      type: "click",
      selector: ".chip",
      callback: (el, event, self) => {
        let chip = event.currentTarget;
        let value = chip.value;
        let max = +el.getAttribute("data-max");

        chip.classList.remove("active");

        el.querySelectorAll(`.dropdown-item[value='${ value }']`)
          .forEach(item => item.classList.remove("selected"));

        $(el.querySelector("input[data-toggle='dropdown']")).dropdown("update");

        if (max === -1 || self.selectedItems(el) < max) {
          self.enableToggle(el);
        }
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
  }
});

Shiny.inputBindings.register(chipInputBinding, "yonder.chipInput");

export let listGroupInputBinding = new Shiny.InputBinding();

$(document).on("click", ".list-group-item-action", (e) => {
  let parent = e.currentTarget.parentNode;

  if (parent.getAttribute("data-multiple") === "false") {
    parent.querySelectorAll(".list-group-item-action.active").forEach(child => {
      child.classList.remove("active");
    });
  }

  e.currentTarget.classList.toggle("active");
});

$.extend(listGroupInputBinding, {
  Selector: {
    SELF: ".yonder-list-group",
    SELECTED: ".list-group-item-action.active:not(.disabled)"
  },
  Events: [
    { type: "click" }
  ],
  _update: (el, data) => {
    let children = el.querySelectorAll(".list-group-item");

    if (data.choices) {
      children.forEach((child, i) => {
        child.innerHTML = data.choices[i];
        child.setAttribute("data-value", data.values[i]);
      });
    }

    if (data.selected) {
      let current = el.querySelector(".list-group-item.active");
      if (current !== null) {
        current.classList.remove("active");
      }

      let selected = data.selected.length ? data.selected : [data.selected];
      children.forEach(child => {
        if (selected.indexOf(child.getAttribute("data-value")) > -1) {
          child.classList.add("active");
        }
      });
    }
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "yonder.listGroupInput");

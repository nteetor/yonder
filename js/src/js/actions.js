let deactivateRelatives = function(el) {
  el.parentNode
    .querySelectorAll(".tab-pane[id]")
    .forEach(pane => {
      document.querySelectorAll(`[data-target="#${ pane.id }"]`)
        .forEach(t => t.classList.remove("active"));
    });
};

let actionPerform = function(el) {
  let plugin = el.getAttribute("data-plugin");
  let action = el.getAttribute("data-action");
  let target = el.getAttribute("data-target");

  if (!(plugin && action && target)) {
    return;
  }

  if (document.querySelector(target).classList.contains("show")) {
    return;
  }

  if (plugin === "tab") {
    deactivateRelatives(document.querySelector(target));
  }

  $(el)[plugin](action);

  if (el.tagName === "BUTTON") {
    if (el.classList.contains("btn")) {
      window.setTimeout(() => el.classList.remove("active"), 1);
    }

    if (el.classList.contains("dropdown-item")) {
      window.setTimeout(() => {
        el.querySelector(".dropdown-toggle").classList.remove("active");
      }, 1);
    }
  } else if (el.tagName === "INPUT") {
    window.setTimeout(() => el.classList.remove("active"), 1);
  }
};

// $(() => {
//   let active = document.querySelectorAll(".active[data-plugin], input:checked[data-plugin]");

//   active.forEach(a => actionPerform(a));
// });

export let actionListener = function(el, selector, event) {
  $(el).on(event, selector, (e) => {
    let clicked = e.currentTarget;

    actionPerform(clicked);
  });
};

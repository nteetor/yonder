let deactivateRelatives = function(el) {
  el.parentNode
    .querySelectorAll(".tab-pane[id]")
    .forEach(pane => {
      document.querySelectorAll(`[data-target="#${ pane.id }"]`)
        .forEach(t => t.classList.remove("active"));
    });
};

export let actionListener = function(el, selector) {
  $(selector).on("click", (e) => {
    // necessary to prevent `data-target` default activation
    e.stopPropagation();

    let clicked = e.currentTarget;

    let plugin = clicked.getAttribute("data-toggle");
    let action = clicked.getAttribute("data-action");
    let target = clicked.getAttribute("data-target");

    if (document.querySelector(target).classList.contains("show")) {
      return;
    }

    if (plugin === "tab") {
      deactivateRelatives(document.querySelector(target));
    }

    // el.querySelectorAll(`[data-toggle="${ action }"]`)
    //   .forEach(child => child.classList.remove("active"));
    //     document.querySelectorAll(`
    //   });

    $(clicked)[plugin](action);

    // if (el === clicked) {
    //   // ensure the target is clickable again
    //   window.setTimeout(() => el.classList.remove("active"), 100);
    // }
  });
};

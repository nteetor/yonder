export let navInputBinding = new Shiny.InputBinding();

$.extend(navInputBinding, {
  Selector: {
    SELF: ".yonder-nav",
    SELECTED: ".nav-link.active:not(.disabled)"
  },
  Events: [
    {
      type: "click",
      selector: ".nav-link:not(.dropdown-toggle):not(.disabled)",
      callback: (el, e) => {
        let activeItem = el.querySelector(".dropdown-item.active");
        if (activeItem !== null) {
          // trigger reset on menu input
          $(activeItem.parentNode.parentNode).trigger("nav.reset");
        }

        el.querySelectorAll(".nav-link.active").forEach(a => {
          a.classList.remove("active");
        });

        e.currentTarget.classList.add("active");
      }
    },
    {
      type: "click",
      selector: ".dropdown-item:not(.disabled)",
      callback: (el, e) => {
        el.querySelectorAll(".active").forEach(a => {
          a.classList.remove("active");
        });

        e.currentTarget.parentNode.parentNode.children[0].classList.add("active");
        e.currentTarget.classList.add("active");
      }
    }
  ],
  _update: (el, data) => {
    let template = el.querySelector(".nav-item").cloneNode(true);
    template.children[0].classList.remove("active");
    template.children[0].classList.remove("disabled");

    el.innerHTML = "";

    data.choices.forEach((choice, i) => {
      let child = template.cloneNode(true);
      child.children[0].innerHTML = choice;
      child.children[0].value = data.values[i];

      if (data.selected.indexOf(data.values[i]) > -1) {
        child.children[0].classList.add("active");
      }

      el.appendChild(child);
    });
  },
  _disable: function(el, data) {
    el.querySelectorAll(".nav-link").forEach(nl => {
      let disabled = !data.values.length || data.values.indexOf(nl.value) > -1;

      if (data.reset) {
        nl.classList.remove("disabled");
      }

      if (disabled !== data.invert) {
        nl.classList.add("disabled");
      }
    });
  },
  _enable: function(el, data) {
    el.querySelectorAll(".nav-link").forEach(nl => {
      let enable = !data.values.length || data.values.indexOf(nl.value) > -1;

      if (enable !== data.invert) {
        nl.classList.remove("disabled");
      }
    });
  }
});

Shiny.inputBindings.register(navInputBinding, "yonder.navInput");

Shiny.addCustomMessageHandler("yonder:pane", (msg) => {
  let _show = function(pane) {
    if (pane === null ||
        !pane.parentElement.classList.contains("tab-content")) {
      return;
    }

    let previous = pane.parentElement.querySelector(".active");

    const complete = () => {
      const hiddenEvent = $.Event("hidden.bs.tab", {
        relatedTarget: pane
      });

      const shownEvent = $.Event("shown.bs.tab", {
        relatedTarget: previous
      });

      $(previous).trigger(hiddenEvent);
      $(pane).trigger(shownEvent);
    };

    bootstrap.Tab.prototype._activate(pane, pane.parentElement, complete);
  };

  // let _hide = function(pane) {
  //   let current = pane.parent
  // };

  if (msg.type === undefined ||
      msg.data === undefined ||
      msg.data.target === undefined) {
    return;
  }

  if (msg.type === "show") {
    _show(document.getElementById(msg.data.target));
  }
});

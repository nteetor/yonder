export let navInputBinding = new Shiny.InputBinding();

$.extend(navInputBinding, {
  Selector: {
    SELF: ".yonder-nav[id]",
    CHILD: ".nav-item",
    CHOICE: ".nav-link",
    VALUE: ".nav-link",
    SELECTED: ".active"
  },
  Events: [
    {
      type: "click",
      selector: "a",
      callback: el => false
    },
    {
      type: "click",
      selector: ".nav-link:not(.dropdown-toggle):not(.disabled)",
      callback: (el, target) => {
        el.querySelectorAll(".active").forEach(a => a.classList.remove("active"));
        target.classList.add("active");
      }
    },
    {
      type: "click",
      selector: ".dropdown-item:not(.disabled)",
      callback: (el, target) => {
        el.querySelectorAll(".active").forEach(a => a.classList.remove("active"));

        target.parentNode.parentNode.firstElementChild.classList.add("active");
        target.classList.add("active");
      }
    }
  ],
  _disable: function(el, data) {
    el.querySelectorAll("[data-value]").forEach(child => {
      let value = child.getAttribute("data-value");
      let index = data.values ? data.values.indexOf(value) : 0;

      if ((index > -1) === !data.invert) {
        child.classList.add("disabled");
      } else if (data.reset) {
        child.classList.remove("disabled");
      }
    });
  },
  _enable: function(el, data) {
    el.querySelectorAll("[data-value]").forEach(child => {
      let value = child.getAttribute("data-value");
      let index = data.values ? data.values.indexOf(value) : 0;

      if ((index > -1) === !data.invert) {
        child.classList.remove("disabled");
      }
    });
  }
});

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

Shiny.inputBindings.register(navInputBinding, "yonder.navInput");

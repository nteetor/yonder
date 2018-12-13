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
        el.querySelectorAll(".active").forEach(a => {
          a.classList.remove("active");
        });

        e.target.classList.add("active");
      }
    },
    {
      type: "click",
      selector: ".dropdown-item:not(.disabled)",
      callback: (el, e) => {
        el.querySelectorAll(".active").forEach(a => {
          a.classList.remove("active");
        });

        e.target.parentNode.parentNode.children[0].classList.add("active");
        e.target.classList.add("active");
      }
    }
  ],
  _value: function(el, newValue, currentValue, index) {
    if (currentValue !== null) {
      let target = el.querySelector(`.nav-link[data-value="${ currentValue  }"]`);

      if (target !== null) {
        target.setAttribute("data-value", newValue);
      }
    } else {
      let possibles = el.querySelectorAll(".nav-link");

      if (index < possibles.length) {
        possibles[index].setAttribute("data-value", newValue);
      }
    }
  },
  _choice: function(el, newLabel, currentValue, index) {
    if (currentValue !== null) {
      let child = el.querySelector(`.nav-link[data-value="${ currentValue }"]`);

      if (child !== null) {
        child.innerHTML = newLabel;
      }
    } else {
      let possibles = el.querySelectorAll(".nav-link");

      if (index < possibles.length) {
        possibles[index].innerHTML = newLabel;
      }
    }
  },
  _select: (el, currentValue, index) => {
    if (currentValue !== null) {
      let target = el.querySelector(`.nav-link[data-value="${ currentValue }"]`);
      if (target !== null) {
        target.classList.add("active");
      }
    } else {
      let children = el.querySelectorAll(".nav-link");
      if (index < children.length) {
        children[index].classList.add("active");
      }
    }
  },
  _clear: (el) => {
    el.querySelectorAll(".nav-link.active")
      .forEach(nl => nl.classList.remove("active"));
  },
  _disable: function(el, data) {
    el.querySelectorAll(".nav-link").forEach(nl => {
      let disabled = !data.values.length || data.values.indexOf(nl.value) > -1;

      if (disabled && !data.invert) {
        nl.classList.add("disabled");
      } else if (data.reset) {
        nl.classList.remove("disabled");
      }
    });
  },
  _enable: function(el, data) {
    el.querySelectorAll(".nav-link").forEach(nl => {
      let enable = !data.values.length || data.values.indexOf(nl.value) > -1;

      if (enable && !data.invert) {
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

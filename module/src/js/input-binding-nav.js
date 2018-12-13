export let navInputBinding = new Shiny.InputBinding();

$.extend(navInputBinding, {
  Selector: {
    SELF: ".yonder-nav[id]",
    SELECTED: ".nav-link.active:not(.disabled)"
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

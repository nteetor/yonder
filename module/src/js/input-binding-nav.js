export let navInputBinding = new Shiny.InputBinding();

$(".yonder-nav .nav-link").on("click", ".nav-link", e => e.preventDefault());

$.extend(navInputBinding, {
  Selector: {
    SELF: ".yonder-nav[id]",
    SELECTED: ".nav-link.active"
  },
  Events: [
    {
      type: "click",
      selector: ".nav-link:not(.dropdown-toggle)",
      callback: (el, target) => {
        el.querySelector(".nav-link.active").classList.remove("active");
        target.classList.add("active");
      }
    },
    {
      type: "click",
      selector: ".dropdown-item",
      callback: (el, target) => {
        el.querySelector(".nav-link.active").classList.remove("active");
        target.parentNode.parentNode.firstElementChild.classList.add("active");
      }
    }
  ]
});

Shiny.addCustomMessageHandler("yonder:pane", (msg) => {
  if (msg.type === undefined) {
    return;
  }

  if (msg.type === "show") {
    if (msg.data.target === undefined) {
      return;
    }

    let panes = document.querySelectorAll(`[data-id="${ msg.data.target }"]`);

    if (panes.length === 0) {
      return;
    }

    for (const pane of panes) {
      if (!pane.parentElement.classList.contains("tab-content")) {
        continue;
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
    }
  }
});

Shiny.inputBindings.register(navInputBinding, "yonder.navInput");

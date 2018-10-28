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
  if (msg.type === undefined ||
      msg.data === undefined ||
      msg.data.target === undefined) {
    return;
  }

  let pane = document.getElementById(msg.data.target);

  if (pane === null ||
      !pane.parentElement.classList.contains("tab-content")) {
    return;
  }

  if (msg.type === "show") {
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

  } else if (msg.type === "after") {

    $(pane).after(msg.data.content);

  } else if (msg.type === "before") {

    $(pane).before(msg.data.content);

  }
});

Shiny.inputBindings.register(navInputBinding, "yonder.navInput");

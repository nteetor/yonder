export let navInputBinding = new Shiny.InputBinding();

$.extend(navInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-nav[id]"),
  initialize: (el) => {
    let $el = $(el);

    $el.on("click", ".nav-link:not(.dropdown-toggle):not(.disabled)", (e) => {
      let active = el.querySelector(".dropdown-item.active");

      if (active !== null) {
        // trigger reset on menu input
        $(active.parentNode.parentNode).trigger("nav.reset");
      }

      el.querySelectorAll(".active").forEach(a => a.classList.remove("active"));

      e.currentTarget.classList.add("active");
    });

    $el.on("click", ".dropdown-item:not(.disabled)", (e) => {
      el.querySelectorAll(".active").forEach(a => a.classList.remove("active"));
      e.currentTarget.parentNode.parentNode.children[0].classList.add("active");
      e.currentTarget.classList.add("active");
    });
  },
  getValue: (el) => {
    let active = el.querySelector(".nav-link.active:not(.disabled)");

    if (active === null) {
      return null;
    }

    return active.value;
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", ".dropdown-item", e => callback());
    $el.on("click.yonder", ".nav-link:not(.dropdown-toggle)", e => callback());
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.querySelectorAll(".nav-item").forEach(item => el.removeChild(item));
      el.insertAdjacentHTML("afterbegin", msg.content);
    }

    if (msg.enable) {
      let enable = msg.enable;

      if (enable === true) {
        el.querySelectorAll(".nav-link").forEach(link => {
          link.classList.remove("disabled");
        });
      } else {
        el.querySelectorAll(".nav-link").forEach(link => {
          if (enable.indexOf(link.value) > -1) {
            link.classList.remove("disabled");
          }
        });
      }
    }

    if (msg.disable) {
      let disable = msg.disable;

      if (disable === true) {
        el.querySelectorAll(".nav-link").forEach(link => {
          link.classList.add("disabled");
        });
      } else {
        el.querySelectorAll(".nav-link").forEach(link => {
          if (disable.indexOf(link.value) > -1) {
            link.classList.add("disabled");
          }
        });
      }
    }
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

  let _hide = function(pane) {
    if (pane === null ||
        !pane.parentElement.classList.contains("tab-content") ||
        !pane.classList.contains("active")) {
      return;
    }

    const complete = () => {
      const hiddenEvent = $.Event("hidden.bs.tab", {
        relatedTarget: pane
      });

      $(pane).trigger(hiddenEvent);
    };

    let dummy = document.createElement("div");

    bootstrap.Tab.prototype._activate(dummy, pane.parentElement, complete);
  };

  if (msg.type === undefined ||
      msg.data === undefined ||
      msg.data.target === undefined) {
    return;
  }

  let target = document.getElementById(msg.data.target);

  if (target === null) {
    return;
  }

  if (msg.type === "show") {
    _show(target);
  } else if (msg.type === "hide") {
    _hide(target);
  }
});

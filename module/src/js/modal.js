$(() => {
  document.body.insertAdjacentHTML("beforeend", "<div class='yonder-modals'></div>");
});

Shiny.addCustomMessageHandler("yonder:modal", function(msg) {
  if (msg.type === undefined) {
    return false;
  }

  let _close = function(data) {
    let modals = document.querySelector(".yonder-modals").childNodes;

    if (modals.length === 0) {
      return;
    }

    if (data.id) {
      modals = Array.prototype.filter.call(modals, m => m.id === data.id);
    }

    modals.forEach((modal) => {
      if (!modal.classList.contains("yonder-modal")) {
        return;
      }

      $(modal).modal("hide");
    });
  };

  let _show = function(data) {
    if (data.id) {
      let possible = document.getElementById(data.id);

      if (possible && possible.classList.contains("yonder-modal")) {
        console.warn("ignoring modal with duplicate id");
        return;
      }
    }

    if (data.dependencies) {
      Shiny.renderDependencies(data.dependencies);
    }

    let container = document.querySelector(".yonder-modals");

    container.insertAdjacentHTML("beforeend", data.content);
    let modal = container.querySelector(".yonder-modal:last-child");

    Shiny.initializeInputs(modal);
    Shiny.bindAll(modal);

    let $modal = $(modal);

    $modal.one("hidden.bs.modal", (e) => {
      if (modal.id) {
        Shiny.onInputChange(modal.id, true);
        setTimeout(() => Shiny.onInputChange(modal.id, null), 100);
      }

      container.removeChild(modal);
    });

    $(modal).modal("show");
  };

  if (msg.type === "close") {
    _close(msg.data);
  } else if (msg.type === "show") {
    _show(msg.data);
  } else {
    console.warn(`no modal ${ msg.type } method`);
  }
});

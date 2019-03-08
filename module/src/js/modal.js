$(() => {
  $(document).on("hidden.bs.modal", ".modal", (e) => {
    Shiny.unbindAll(e.currentTarget);
  });
});

Shiny.addCustomMessageHandler("yonder:modal", function(msg) {
  if (msg.type === undefined) {
    return false;
  }

  let _hide = function(data) {
    $(document.getElementById(data.id)).modal("hide");
  };

  let _show = function(data) {
    let modal = document.getElementById(data.id);

    if (data.exprs) {
      Object.keys(data.exprs).forEach(key => {
        let regex = RegExp(`[{]\\s*${ key }\\s*[}]`, "g");
        modal.innerHTML = modal.innerHTML.replace(regex, data.exprs[key]);
      });
    }

    $(modal).modal("show");
  };

  let _register = function(data) {
    let modal = document.createElement("div");
    modal.classList.add("modal");
    modal.classList.add("fade");
    modal.setAttribute("tabindex", -1);
    modal.setAttribute("role", "dialog");
    modal.setAttribute("id", data.id);

    if (data.dependencies !== undefined) {
      Shiny.renderDependencies(data.dependencies);
    }

    document.body.appendChild(modal);
    modal.insertAdjacentHTML("afterbegin", data.content);

    Shiny.initializeInputs(modal);
    Shiny.bindAll(modal);
  };

  if (msg.type === "hide") {
    _hide(msg.data);
  } else if (msg.type === "show") {
    _show(msg.data);
  } else if (msg.type === "register") {
    _register(msg.data);
  } else {
    console.warn(`no modal ${ msg.type } method`);
  }
});

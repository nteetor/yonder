Shiny.addCustomMessageHandler("yonder:modal", function(msg) {
  if (msg.type === undefined) {
    return false;
  }

  let _close = function(data) {
    $(document.getElementById(data.id)).modal("hide");
  };

  let _show = function(data) {
    let modal = document.getElementById(data.id);

    if (data.exprs) {
      Object.keys(data.exprs).forEach(key => {
        let outlet = modal.querySelector(`span[data-target='${ data.id }__${ key }']`);

        if (outlet) {
          outlet.innerHTML = data.exprs[key];
        }
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

    let content = data.content.replace(/[{]\s*([a-z0-9_.]+)\s*[}]/g, (m, id) => {
      return `<span data-target='${ data.id }__${ id }'></span>`;
    });
    modal.insertAdjacentHTML("afterbegin", content);

    Shiny.initializeInputs(modal);
    Shiny.bindAll(modal);
  };

  if (msg.type === "close") {
    _close(msg.data);
  } else if (msg.type === "show") {
    _show(msg.data);
  } else if (msg.type === "register") {
    _register(msg.data);
  } else {
    console.warn(`no modal ${ msg.type } method`);
  }
});

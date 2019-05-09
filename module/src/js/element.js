Shiny.addCustomMessageHandler("yonder:element", (msg) => {
  let _render = (data) => {
    if (data.dependencies) {
      Shiny.renderDependencies(data.dependencies);
    }

    let container = document.getElementById(data.target);

    if (!container || !container.classList.contains("yonder-element")) {
      return;
    }

    Shiny.unbindAll(container);
    container.innerHTML = data.content;

    Shiny.initializeInputs(container);
    Shiny.bindAll(container);
  };

  let _remove = (data) => {
    let container = document.getElementById(data.target);

    if (!container || !container.classList.contains("yonder-element")) {
      return;
    }

    Shiny.unbindAll(container);

    container.innerHTML = "";
  };

  if (!msg.type) {
    return;
  }

  if (msg.type === "render") {
    _render(msg.data);
  } else if (msg.type === "remove") {
    _remove(msg.data);
  } else {
    console.warn(`no element ${ msg.type } method`);
  }
});

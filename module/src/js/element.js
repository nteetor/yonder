Shiny.addCustomMessageHandler("yonder:element", (msg) => {
  let _render = (data) => {
    if (data.dependencies) {
      Shiny.renderDependencies(data.dependencies);
    }

    let container = document.getElementById(data.target);

    if (container === null) {
      return;
    }

    container.innerHTML = data.content;

    Shiny.initializeInputs(container);
    Shiny.bindAll(container);
  };

  let _remove = (data) => {
    let container = document.getElementById(data.target);

    if (container === null) {
      return;
    }

    Shiny.unbindAll(container);

    container.innerHTML = "";
  };

  console.log(msg);

  if (!msg.type) {
    return;
  }

  if (msg.type === "render") {
    _render(msg.data);
  } else if (msg.type === "remove") {
    _remove(msg.data);
  } else {
    console.warn(`no element method _${ msg.type }`);
  }
});

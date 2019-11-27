Shiny.addCustomMessageHandler("yonder:content", (msg) => {
  let _replace = (data) => {
    if (!data.id) {
      return;
    }

    let target = document.getElementById(data.id);

    if (!target) {
      return;
    }

    if (data.dependencies) {
      Shiny.renderDependencies(data.dependencies);
    }

    if (data.content) {
      Shiny.unbindAll(target);
      target.innerHTML = data.content;
      Shiny.initializeInputs(target);
      Shiny.bindAll(target);
    }

    if (data.attrs) {
      Object.keys(data.attrs).forEach(key => {
        target.setAttribute(key, data.attrs[key]);
      });
    }
  };

  let _remove = (data) => {
    if (!data.id) {
      return;
    }

    let target = document.getElementById(data.id);

    if (!target) {
      return;
    }

    Shiny.unbindAll(target);
    target.innerHTML = "";
  };

  if (!msg.type) {
    return;
  }

  if (msg.type === "replace") {
    _replace(msg.data);
  } else if (msg.type === "remove") {
    _remove(msg.data);
  } else {
    console.warn(`no content "${ msg.type }" method`);
  }
});

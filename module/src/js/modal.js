Shiny.addCustomMessageHandler("yonder:modal", function(msg) {
  if (msg.type === undefined) {
    return false;
  }

  if (msg.type === "close") {
    let modal = document.body.querySelector(".modal");

    if (modal === null) {
      return false;
    }

    Shiny.unbindAll(modal);

    $(modal).modal("hide");

    return true;
  }

  if (msg.type === "show") {
    let modal = document.body.querySelector(".modal");

    if (modal !== null) {
      modal.innerHTML = msg.data.content;
    } else {
      $(document.body).append(
        $(`<div class="modal fade" tabindex=-1 role="dialog">${ msg.data.content }</div>`)
      );
      modal = document.body.querySelector(".modal");
    }

    if (msg.data.dependencies !== undefined) {
      Shiny.renderDependencies(msg.data.dependencies);
    }

    Shiny.initializeInputs(modal);
    Shiny.bindAll(modal);

    $(modal).modal("show");

    return true;
  }

  return false;
});

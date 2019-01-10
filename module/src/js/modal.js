$(() => {
  $(document).on("hidden.bs.modal", ".modal", (e) => {
    Shiny.unbindAll(e.currentTarget);
  });
});

Shiny.addCustomMessageHandler("yonder:modal", function(msg) {
  if (msg.type === undefined) {
    return false;
  }

  let _close = function(data) {
    let modal = document.body.querySelector(".modal");
    $(modal).modal("hide");
  };

  let _show = function(data) {
    let modal = document.body.querySelector(".modal");

    if (modal !== null) {
      modal.innerHTML = data.content;
    } else {
      $(document.body).append(
        $(`<div class="modal fade" tabindex=-1 role="dialog">${ data.content }</div>`)
      );
      modal = document.body.querySelector(".modal");
    }

    if (data.dependencies !== undefined) {
      Shiny.renderDependencies(data.dependencies);
    }

    Shiny.initializeInputs(modal);
    Shiny.bindAll(modal);

    $(modal).modal("show");
  };

  if (msg.type === "close") {
    _close(msg.data);
  } else if (msg.type === "show"){
    _show(msg.data);
  } else {
    console.warn(`no modal ${ msg.type } method`);
  }
});

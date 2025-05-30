$(() => {
  document.body.insertAdjacentHTML("beforeend", "<div class='yonder-toasts'></div>");

  $(".yonder-toasts").on("hidden.bs.toast", ".toast", (e) => {
    if (e.currentTarget.hasAttribute("data-action")) {
      let action = e.currentTarget.getAttribute("data-action");
      Shiny.onInputChange(action, true);
      setTimeout(() => Shiny.onInputChange(action, null), 100);
    }

    e.delegateTarget.removeChild(e.currentTarget);
  });
});

Shiny.addCustomMessageHandler("yonder:toast", (msg) => {
  let _show = function(data) {
    document.querySelector(".yonder-toasts")
      .insertAdjacentHTML("beforeend", data.content);

    $(".yonder-toasts > .toast:last-child").toast("show");
  };

  let _close = function(data) {
    let toasts = document.querySelectorAll(".yonder-toasts .toast");

    if (toasts.length) {
      $(toasts).toast("hide");
    }
  };

  if (!msg.type) {
    return;
  }

  if (msg.type === "show") {
    _show(msg.data);
  } else if (msg.type === "close") {
    _close(msg.data);
  } else {
    console.warn(`no toast ${ msg.type } method`);
  }
});

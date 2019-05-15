Shiny.addCustomMessageHandler("yonder:popover", (msg) => {
  if (!msg.data.id || !document.getElementById(msg.data.id)) {
    return;
  }

  let _show = (data) => {
    let $target = $(document.getElementById(data.id));

    $target.popover({
      content: () => undefined,
      placement: data.placement,
      template: data.content,
      title: () => undefined,
      trigger: "manual"
    });

    if (data.duration) {
      setTimeout(() => $target.popover("hide"), data.duration);
    }

    $target.popover("show");
  };

  let _close = (data) => {
    let target = document.getElementById(data.id);

    if (!target) {
      return;
    }

    $(target).popover("hide");
  };

  if (msg.type === "show") {
    _show(msg.data);
  } else if (msg.type === "close") {
    _close(msg.data);
  } else {
    console.warn(`no "${ msg.type }" popover method`);
  }
});

let linkInputBindng = new Shiny.InputBinding();

$.extend(linkInputBindng, {
  Selector: {
    SELF: ".dull-link-input"
  },
  Events: [
    { type: "click", callback: (el) => el.dataset.value++ }
  ],
  initialize: function(el) {
    el.dataset.value = 0;
  },
  getType: function(el) {
    return "dull.link";
  },
  getValue: function(el) {
    return {
      value: el.dataset.value,
      id: el.id
    };
  }
});

Shiny.inputBindings.register(linkInputBindng, "dull.linkInput");

Shiny.addCustomMessageHandler("dull:popover", (msg) => {
  if (!msg.id) {
    return;
  }

  msg.id = `#${ msg.id }`;

  if (msg.type == "show") {
    let data = msg.data;

    $(msg.id).popover({
      title: data.title || "",
      content: data.content,
      placement: data.placement,
      trigger: "manual"
    });

    if (data.duration) {
      setTimeout(
        () => {
          $(document).off(".removePopover");
          $(msg.id).popover("hide");
        },
        data.duration
      );

      $(document).one("click.removePopover", (e) => {
        $(msg.id).popover("hide");
      });
    }

    $(msg.id).popover("show");

    return;
  }

  if (msg.type == "close") {
    $(msg.id).popover("hide");
//    $(msg.id).popover("disable");

    return;
  }
});

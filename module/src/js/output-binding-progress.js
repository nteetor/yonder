$.extend(Shiny.progressHandlers, {
  "yonder-progress": (msg) => {
    if (!msg.type || !msg.data.outlet) {
      return false;
    }

    let $outlet = $(`#${ msg.data.outlet }`);

    if (msg.type === "show") {
      let $bar = $(msg.data.content);

      if ($bar[0].id && $outlet.find(`#${ $bar[0].id }`).length) {
        $outlet.find(`#${ $bar[0].id }`).replaceWith($bar);
      } else {
        $outlet.append($bar);
      }

      return true;
    }

    return false;
  }
});

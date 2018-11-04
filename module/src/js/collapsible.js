Shiny.addCustomMessageHandler("yonder:collapse", (msg) => {
  if (msg.type === undefined ||
      msg.data === undefined ||
      msg.data.target === undefined) {
    return false;
  }

  if (msg.type === "show" || msg.type === "hide" || msg.type === "toggle") {
    let target = document.getElementById(msg.data.target);

    if (target === null) {
      return false;
    }

    $(target).collapse(msg.type);
    return true;
  }

  return false;
});

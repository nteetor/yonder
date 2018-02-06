Shiny.addCustomMessageHandler("dull:alert", function(msg) {
  var ids = msg.id.map(v => "#" + v).join(",");

  $("<div>")
    .addClass("alert alert-dismissible fade show")
    .html(msg.content)
    .append(
      $("<button>", {
        "type": "button",
        "class": "close",
        "data-dismiss": "alert",
        "aria-label": "Close"
      }).append(
        $("<span>", {
          "class": "fas fa-window-close",
          "aria-hidden": true
        })
      )
    )
    .insertBefore($(ids));
});

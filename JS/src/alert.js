Shiny.addCustomMessageHandler("dull:alert", function(msg) {
  console.log(msg.id);
  var ids = msg.id.map(v => "#" + v).join(",");

  $("<div>")
    .addClass("alert alert-dismissible alert-" + msg.context + " fade show")
    .html(msg.content)
    .append(
      $("<button>", {
        "type": "button",
        "class": "close",
        "data-dismiss": "alert",
        "aria-label": "Close"
      }).append(
        $("<span>", {
          "class": "fa fa-times-rectangle",
          "aria-hidden": true
        })
      )
    )
    .insertBefore($(ids));
});

Shiny.addCustomMessageHandler("dull:modal", function(msg) {
  var modal = $("<div>", {
    "class": "modal fade",
    "tabindex": -1,
    "role": "dialog"
  }).append(
    $("<div>", {
      "class": "modal-dialog",
      "role": "document"
    }).append(
      $("<div>", {
        "class": "modal-content"
      }).append(
        $("<div>", {
          "class": "modal-header"
        }).append(
          $("<h5>", {"class": "modal-title"}).html(msg.title),
          $("<button>", {
            "type": "button",
            "class": "close",
            "data-dismiss": "modal",
            "aria-label": "Close",
          }).append(
            $("span", {
              "class": "fa fa-times-rectangle"
            })
          )
        ),
        $("<div>", {"class": "modal-body"}).html(msg.body)
      )
    )
  );

  if (msg.footer) {
    modal.find(".modal-content").append(
      $("<div>", {
        "class": "modal-footer"
      }).html(
        msg.footer
      )
    );
  }

  modal.modal("toggle");
});

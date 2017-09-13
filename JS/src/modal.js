Shiny.addCustomMessageHandler("dull:modal", function(msg) {
  if (msg.close === true) {
    $(".modal").modal("hide");
    return true;
  }

  if ($(".modal").length) {
    modal = $(".modal");
  } else {
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
            $("<h5>", {"class": "modal-title"}),
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
          $("<div>", {
            "class": "container-fluid"
          }).append(
            $("<div>", {"class": "modal-body"})
          )
        )
      )
    );

    $("<body>").append(modal);
  }

  $(".modal-title").html(msg.title);
  $(".modal-body").html(msg.body);

  if (msg.footer) {
    if (!$(".modal-footer").length) {
      $(".modal-content").append(
        $("<div>", {
          "class": "modal-footer"
        }).html(
          msg.footer
        )
      );
    } else {
      $(".modal-content").html(msg.footer);
    }
  }

});

$(document).ready(function() {
  $(document).on("shown.bs.modal", ".modal", function(e) {
    console.log(
      $(".modal").find(".shiny-bound-output, .shiny-bound-input").length
    );
    if (!$(".modal").find(".shiny-bound-output, .shiny-bound-input").length) {
      console.log("no bound found");
      Shiny.initializeInputs(".modal");
      Shiny.bindAll(".modal");
    }
  });
});

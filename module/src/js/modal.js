Shiny.addCustomMessageHandler("dull:modal", function(msg) {
  if (msg.close === true) {
    $(".modal").modal("hide");
    return true;
  }

  var $modal;

  if ($(".modal").length) {
    $modal = $(".modal");
  } else {
    $modal = $([
      "<div class='modal fade' tabindex=-1 role='dialog'>",
      "<div class='modal-dialog' role='document'>",
      "<div class='modal-content'>",
      "<div class='modal-header'>",
      "<h5 class='modal-title'></h5>",
      "<button type='button' class='close' data-dismiss='modal' aria-label='Close'>",
      "<span class='fa fa-times-rectangle'></span>",
      "</button>",
      "</div>",
      "<div class='container-fluid'>",
      "<div class='modal-body'></div>",
      "</div>",
      "</div>",
      "</div>",
      "</div>"
    ].join("\n"));

    $("body").append($modal);
  }


  $(".modal-title", $modal).html(msg.title);
  $(".modal-body", $modal).html(msg.body);

  if (msg.footer) {
    if (!$(".modal-footer", $modal).length) {
      $(".modal-content", $modal).append($("<div class='modal-footer'></div>"));
    }

    $(".modal-content", $modal).html(msg.footer);
  }

  $modal.modal();
});

$(document).ready(function() {
  $(document).on("shown.bs.modal", ".modal", function(e) {
    if (!$(".modal").find(".shiny-bound-output, .shiny-bound-input").length) {
      Shiny.initializeInputs(".modal");
      Shiny.bindAll(".modal");
    }
  });
});

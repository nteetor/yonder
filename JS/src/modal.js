Shiny.addCustomMessageHandler("dull.modal.toggle", function(msg) {
  var $modal = $(msg.id);

  if ($modal.length === 0) {
    return false;
  }

  $modal.modal("toggle");
});

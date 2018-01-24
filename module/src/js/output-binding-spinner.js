$.extend(Shiny.progressHandlers, {
  "dull-spinner": function(msg) {
    var $spinner = $("#" + msg.id);

    if (!$spinner.is(".dull-spinner-output")) {
      return false;
    }

    if (msg.action === "start") {
      $spinner.removeClass("pause");
    }

    if (msg.action == "stop") {
      $spinner.addClass("pause");
    }
  }
});

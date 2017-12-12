$.extend(Shiny.progressHandlers, {
  "dull-stream": function(data) {
    var classes;
    if (data.context) {
      classes = "list-group-item list-group-item-" + data.context;
    } else {
      classes = "list-group-item";
    }

    $("<li class='" + classes + "'></li>")
      .text(data.message)
      .hide()
      .appendTo($("#" + data.id))
      .fadeIn(300);

    return false;
  }
});

$.extend(Shiny.progressHandlers, {
  "dull-stream": function(data) {
    $("<li class='list-group-item'></li>")
      .text(data.content)
      .hide()
      .appendTo($("#" + data.id))
      .fadeIn(300);

    return false;
  }
});

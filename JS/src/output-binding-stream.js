$.extend(Shiny.progressHandlers, {
  dull: function(data) {
    $("<li>")
      .addClass("list-group-item")
      .addClass(data.context ? "list-group-item-" + data.context : "")
      .text(data.message)
      .hide()
      .appendTo($("#" + data.id))
      .fadeIn(300);

    return false;
  }
});

$.extend(Shiny.progressHandlers, {
  dull: function(message) {
    $('<li class="list-group-item">' + message.content + "</li>")
      .hide()
      .appendTo($(message.id))
      .fadeIn(300);

    return false;
  }
});

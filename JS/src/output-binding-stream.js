$.extend(Shiny.progressHandlers, {
  dull: function(message) {
    console.log(message);
    $el = $(message.id);

    if ($el.children().length === 0) {
      $el.html("<p>" + message.content + "</p>");
    } else {
      $el.children().last().after("<p>" + message.content + "</p>");
    }

    return false;
  }
});

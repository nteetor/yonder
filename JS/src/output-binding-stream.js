$.extend(Shiny.progressHandlers, {
  dull: function(data) {
    console.log(data.template);

    $(data.template)
      .text(data.content)
      .hide()
      .appendTo($(data.id))
      .fadeIn(300);

    return false;
  }
});

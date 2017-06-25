$(function() {
  $('[data-toggle="tooltip"]').tooltip();
});

$(function() {
  $('[data-toggle="popover"]').popover();
});

$(document).on("shiny:connected", function() {
  $('button[data-type="submit"]').attr("type", "submit");
});

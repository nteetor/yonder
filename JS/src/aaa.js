$(function() {
  $("[data-toggle=\"tooltip\"]").tooltip();
});

$(function() {
  $("[data-toggle=\"popover\"]").popover();
});

$(document).on("shiny:connected", function() {
  $(".dull-submit[data-type=\"submit\"]").attr("type", "submit");
});

$(function() {
  Shiny.addCustomMessageHandler("dull:collapse", function(msg) {
  	var $el = $("#" + msg.id);

  	if ($el.length === 0 || !msg.action) {
  	    return false;
  	}

  	$el.collapse(msg.action);
  });
});

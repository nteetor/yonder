$(function() {
  $("[data-toggle=\"tooltip\"]").tooltip();
});

$(function() {
  $("[data-toggle=\"popover\"]").popover();
});

$(function() {
  $(".nav:not([role='tablist']) li").on("click", function(e) {
    var $this = $(this);
    $(".nav-link", $this.parent(".nav")).removeClass("active");
    $(".nav-link", $this).addClass("active");
  });
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

  Shiny.addCustomMessageHandler("dull:download", function(msg) {
    var uri = "/session/" + msg.token + "/download/" + msg.name;

    $.get(uri, function() {
      window.location = uri;
    })
    .fail(function() {
      alert("An error occurred during download.");
    });
  });
});

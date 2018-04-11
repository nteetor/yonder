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
    if (!(msg.filename && msg.token && msg.key)) {
      throw "invalid download event";
    }

    const uri = "/session/" + msg.token + "/download/" + msg.key;

    let agent = window.navigator.userAgent;
    let ie = ua.indexOf("MSIE ");

    if (ie > 0) {
      let xhr = new XMLHttpRequest();
      xhr.open("GET", uri);
      xhr.responseType = "blob";
      xhr.onload = () => saveAs(xhr.response, msg.filename);
      xhr.send();
    } else {
      fetch(uri)
        .then(res => res.blob())
        .then(blob => {
          saveAs(blob, msg.filename);
        });
    }
  });
});

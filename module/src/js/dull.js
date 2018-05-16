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

$(() => {
  let collapsibles = document.querySelectorAll("[data-collapse-id]");

  if (collapsibles.length) {
    $(collapsibles).wrap(function() {
      let data = this.dataset;
      let attrs = {};

      for (let key of Object.keys(data)) {
        if (key.match(/^collapse/)) {
          let newkey = key.replace(/([A-Z])/g, "-$1")
              .toLowerCase()
              .replace(/^collapse-/, "");

          attrs[newkey] = data[key];
        }
      }

      attrs["class"] = `${ attrs["class"] ? attrs["class"] + " " : ""}collapse`;

      return $("<div>", attrs);
    });

    $(document.querySelectorAll(".collapse")).collapse();
  }

  Shiny.addCustomMessageHandler("dull:collapse", function(msg) {
    if (!msg.type || !msg.type.match(/^(show|hide|toggle)$/)) {
      return;
    }

    let collapsible = document.getElementById(`${ msg.data.id }`);

    if (!collapsible || !collapsible.classList.contains("collapse")) {
      return;
    }

    $(collapsible).collapse(msg.type);
  });
});

$(() => {
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

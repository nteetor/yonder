import { yonderInputBinding } from "./yonder-input-binding.js";

import "./input-binding-address.js";
import "./input-binding-alert.js";
import "./input-binding-button-group.js";
import "./input-binding-button.js";
import "./input-binding-checkbar.js";
import "./input-binding-checkbox.js";
import "./input-binding-date.js";
import "./input-binding-file.js";
import "./input-binding-form.js";
import "./input-binding-group-input.js";
import "./input-binding-link.js";
import "./input-binding-login.js";
import "./input-binding-nav.js";
import "./input-binding-radio.js";
import "./input-binding-radiobar.js";
import "./input-binding-range.js";
import "./input-binding-select.js";
import "./input-binding-tabs.js";
import "./input-binding-textual.js";

import "./output-binding-badge.js";
import "./output-binding-sparkline.js";
import "./output-binding-progress.js";

import "./thruput-binding-table.js";
import "./thruput-binding-list-group.js";

yonderInputBinding.call(Shiny.InputBinding.prototype);

$(() => {
  $("[data-toggle=\"tooltip\"]").tooltip();
  $("[data-toggle=\"popover\"]").popover();

  $(".yonder-file").on("click", ".input-group-append", function(e) {
    $(e.delegateTarget).find("input[type='file']").trigger("click");
  });

  $(".nav:not([role='tablist']) li").on("click", function(e) {
    var $this = $(this);
    $(".nav-link", $this.parent(".nav")).removeClass("active");
    $(".nav-link", $this).addClass("active");
  });

  $(document).on("shiny:connected", function() {
    $(".yonder-submit[data-type=\"submit\"]").attr("type", "submit");
  });

  $(document).on("shown.bs.modal", ".modal", function(e) {
    if (!$(".modal").find(".shiny-bound-output, .shiny-bound-input").length) {
      Shiny.initializeInputs(".modal");
      Shiny.bindAll(".modal");
    }
  });

  (() => {
    let collapsibles = document.querySelectorAll("[data-collapse-id]");

    if (collapsibles.length) {
      $(collapsibles).wrap(function() {
        let attrs = {};

        for (const attr of this.attributes) {
          if (attr.name.match(/^data[-]collapse/)) {
            let newkey = attr.name.replace(/([A-Z])/g, "-$1")
                .toLowerCase()
                .replace(/^data-collapse-/, "");

            attrs[newkey] = attr.value;
          }
        }

        attrs["class"] = `${ attrs["class"] ? attrs["class"] + " " : ""}collapse`;

        return $("<div>", attrs);
      });

      $(document.querySelectorAll(".collapse")).collapse();
    }
  })();

  Shiny.addCustomMessageHandler("yonder:collapse", function(msg) {
    if (!msg.type || !msg.type.match(/^(show|hide|toggle)$/)) {
      return;
    }

    let collapsible = document.getElementById(`${ msg.data.id }`);

    if (!collapsible || !collapsible.classList.contains("collapse")) {
      return;
    }

    $(collapsible).collapse(msg.type);
  });

  Shiny.addCustomMessageHandler("yonder:popover", (msg) => {
    if (msg.data.target === undefined) {
      return;
    }

    if (msg.type == "show") {
      let data = msg.data;
      let target = `#${ data.target }`;

      $(target).popover({
        title: () => undefined,
        content: () => undefined,
        template: data.content,
        placement: data.placement,
        trigger: "manual"
      });

      if (data.duration) {
        setTimeout(
          () => $(target).popover("hide"),
          data.duration
        );
      }

      $(target).popover("show");

      return;
    }

    if (msg.type == "close") {
      $(`#${ msg.data.id }`).popover("hide");

      return;
    }
  });

  Shiny.addCustomMessageHandler("yonder:modal", function(msg) {
    if (!msg.type) {
      return false;
    }

    if (msg.type === "close") {
      $(".modal").modal("hide");
      return true;
    }

    if (msg.type === "show") {
      var $modal;

      if ($(".modal").length) {
        $modal = $(".modal");
      } else {
        $modal = $("<div class='modal fade' tabindex=-1 role='dialog'></div>");

        $(document.body).append($modal);
      }

      $modal.html(msg.data.content);
      $modal.modal();

      return true;
    }

    return false;
  });

  Shiny.addCustomMessageHandler("yonder:download", function(msg) {
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

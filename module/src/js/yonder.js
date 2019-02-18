import "./yonder-input-binding.js";

import "./input-binding-button-group.js";
import "./input-binding-button.js";
import "./input-binding-checkbar.js";
import "./input-binding-checkbox.js";
import "./input-binding-chip.js";
import "./input-binding-file.js";
import "./input-binding-form.js";
import "./input-binding-group-input.js";
import "./input-binding-link.js";
import "./input-binding-list-group.js";
import "./input-binding-menu.js";
import "./input-binding-nav.js";
import "./input-binding-radio.js";
import "./input-binding-radiobar.js";
import "./input-binding-range.js";
import "./input-binding-select.js";
import "./input-binding-textual.js";

import "./output-binding-badge.js";
import "./output-binding-progress.js";

import "./thruput-binding-table.js";

import "./collapsible.js";
import "./element.js";
import "./modal.js";
import "./toast.js";

$(() => {
  $("[data-toggle=\"tooltip\"]").tooltip();
  $("[data-toggle=\"popover\"]").popover();

  $(document).on("shiny:connected", function() {
    $(".yonder-submit[data-type=\"submit\"]").attr("type", "submit");
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

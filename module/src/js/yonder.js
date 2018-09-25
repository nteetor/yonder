import { yonderInputBinding } from "./yonder-input-binding.js";

import { addressInputBinding } from "./input-binding-address.js";
import { alertInputBinding } from "./input-binding-alert.js";
import { buttonGroupInputBinding } from "./input-binding-button-group.js";
import { buttonInputBinding } from "./input-binding-button.js";
import { checkbarInputBinding } from "./input-binding-checkbar.js";
import { checkboxInputBinding } from "./input-binding-checkbox.js";
import { dateInputBinding } from "./input-binding-date.js";
import { fileInputBinding } from "./input-binding-file.js";
import { formInputBinding } from "./input-binding-form.js";
import { groupInputBinding } from "./input-binding-group-input.js";
import { linkInputBinding } from "./input-binding-link.js";
import { loginInputBinding } from "./input-binding-login.js";
import { navInputBinding } from "./input-binding-nav.js";
import { radioInputBinding } from "./input-binding-radio.js";
import { radiobarInputBinding } from "./input-binding-radiobar.js";
import { rangeInputBinding } from "./input-binding-range.js";
import { selectInputBinding } from "./input-binding-select.js";
import { tabsInputBinding } from "./input-binding-tabs.js";
import { textualInputBinding } from "./input-binding-textual.js";

import { badgeOutputBinding } from "./output-binding-badge.js";
import { sparklineOutputBinding } from "./output-binding-sparkline.js";
// import { tooltipOutputBinding } from "./output-binding-tooltip.js";

import { tableInputBinding, tableOutputBinding } from "./thruput-binding-table.js";
import { listGroupInputBinding, listGroupOutputBinding } from "./thruput-binding-list-group.js";

const inputBindings = {
  "yonder.addressInput": addressInputBinding,
  "yonder.alertInput": alertInputBinding,
  "yonder.buttonGroupInput": buttonGroupInputBinding,
  "yonder.buttonInput": buttonInputBinding,
  "yonder.checkbarInput": checkbarInputBinding,
  "yonder.checkboxInput": checkboxInputBinding,
  "yonder.dateInput": dateInputBinding,
  "yonder.fileInput": fileInputBinding,
  "yonder.formInput": formInputBinding,
  "yonder.groupInput": groupInputBinding,
  "yonder.linkInput": linkInputBinding,
  "yonder.loginInput": loginInputBinding,
  "yonder.navInput": navInputBinding,
  "yonder.radioInput": radioInputBinding,
  "yonder.radiobarInput": radiobarInputBinding,
  "yonder.rangeInput": rangeInputBinding,
  "yonder.selectInput": selectInputBinding,
  "yonder.tableInput": tableInputBinding,
  "yonder.tabsInput": tabsInputBinding,
  "yonder.textualInput": textualInputBinding,
  "yonder.listGroupInputBinding": listGroupInputBinding
};

const outputBindings = {
  "yonder.badgeOutput": badgeOutputBinding,
  "yonder.sparklineOutput": sparklineOutputBinding,
  "yonder.tableOutput": tableOutputBinding,
  "yonder.listGroupOutput": listGroupOutputBinding
};

yonderInputBinding.call(Shiny.InputBinding.prototype);

Object.keys(inputBindings).forEach(key => {
  Shiny.inputBindings.register(inputBindings[key], key);
});

Object.keys(outputBindings).forEach(key => {
  Shiny.outputBindings.register(outputBindings[key], key);
});

$(() => {
  $("[data-toggle=\"tooltip\"]").tooltip();
});

$(() => {
  $("[data-toggle=\"popover\"]").popover();
});

$(() => {
  $(".yonder-file").on("click", ".input-group-append", function(e) {
    $(e.delegateTarget).find("input[type='file']").trigger("click");
  });
});

$(() => {
  $("body").append(
    $("<div class='yonder-alert-container' id='alert-container'></div>")
  );
});

$(() => {
  $(".nav:not([role='tablist']) li").on("click", function(e) {
    var $this = $(this);
    $(".nav-link", $this.parent(".nav")).removeClass("active");
    $(".nav-link", $this).addClass("active");
  });
});

$(document).on("shiny:connected", function() {
  $(".yonder-submit[data-type=\"submit\"]").attr("type", "submit");
});

$(() => {
  $(document).on("shown.bs.modal", ".modal", function(e) {
    if (!$(".modal").find(".shiny-bound-output, .shiny-bound-input").length) {
      Shiny.initializeInputs(".modal");
      Shiny.bindAll(".modal");
    }
  });
});

$.extend(Shiny.progressHandlers, {
  "yonder-progress": (msg) => {
    var $bar = $(".yonder-progress #" + msg.id);

    $bar
      .attr("style", (i, s) => s.replace(/width: [0-9]+%/, "width: " + msg.value + "%"))
      .attr("aria-valuenow", msg.value);

    if (msg.label) {
      $bar.text(msg.label);
    }

    if (msg.context) {
      $bar.attr("class", function(i, c) {
        return c.replace(/bg-(?:primary|secondary|success|info|warning|danger|light|dark|white)/g, "bg-" + msg.context);
      });
    }
  }
});

$.extend(Shiny.progressHandlers, {
  "yonder-stream": (data) => {
    $("<li class='list-group-item'></li>")
      .text(data.content)
      .hide()
      .appendTo($("#" + data.id))
      .fadeIn(300);

    return false;
  }
});

$(() => {
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
});

$(() => {
  Shiny.addCustomMessageHandler("yonder:popover", (msg) => {
    if (!msg.id) {
      return;
    }

    msg.id = `#${ msg.id }`;

    if (msg.type == "show") {
      let data = msg.data;

      $(msg.id).popover({
        title: data.title || "",
        content: data.content,
        placement: data.placement,
        trigger: "manual"
      });

      if (data.duration) {
        setTimeout(
          () => {
            $(document).off(".removePopover");
            $(msg.id).popover("hide");
          },
          data.duration
        );

        $(document).one("click.removePopover", (e) => {
          $(msg.id).popover("hide");
        });
      }

      $(msg.id).popover("show");

      return;
    }

    if (msg.type == "close") {
      $(msg.id).popover("hide");
      //    $(msg.id).popover("disable");

      return;
    }
  });
});

$(() =>  {
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
});

$(() => {
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

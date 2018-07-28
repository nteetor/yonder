import { dullInputBinding } from "./dull-input-binding.js";

import { addressInputBinding } from "./input-binding-address.js";
import { alertInputBinding } from "./input-binding-alert.js";
import { buttonGroupInputBinding } from "./input-binding-button-group.js";
import { buttonInputBinding } from "./input-binding-button.js";
import { checkbarInputBinding } from "./input-binding-checkbar.js";
import { checkboxInputBinding } from "./input-binding-checkbox.js";
import { dateInputBinding } from "./input-binding-date.js";
import { dropdownInputBinding } from "./input-binding-dropdown.js";
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
  "dull.addressInput": addressInputBinding,
  "dull.alertInput": alertInputBinding,
  "dull.buttonGroupInput": buttonGroupInputBinding,
  "dull.buttonInput": buttonInputBinding,
  "dull.checkbarInput": checkbarInputBinding,
  "dull.checkboxInput": checkboxInputBinding,
  "dull.dateInput": dateInputBinding,
  "dull.dropdownInput": dropdownInputBinding,
  "dull.fileInput": fileInputBinding,
  "dull.formInput": formInputBinding,
  "dull.groupInput": groupInputBinding,
  "dull.linkInput": linkInputBinding,
  "dull.loginInput": loginInputBinding,
  "dull.navInput": navInputBinding,
  "dull.radioInput": radioInputBinding,
  "dull.radiobarInput": radiobarInputBinding,
  "dull.rangeInput": rangeInputBinding,
  "dull.selectInput": selectInputBinding,
  "dull.tableInput": tableInputBinding,
  "dull.tabsInput": tabsInputBinding,
  "dull.textualInput": textualInputBinding,
  "dull.listGroupInputBinding": listGroupInputBinding
};

const outputBindings = {
  "dull.badgeOutput": badgeOutputBinding,
  "dull.sparklineOutput": sparklineOutputBinding,
  "dull.tableOutput": tableOutputBinding,
  "dull.listGroupOutput": listGroupOutputBinding
};

dullInputBinding.call(Shiny.InputBinding.prototype);

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
  $(".dull-file-input").on("click", ".input-group-append", function(e) {
    $(e.delegateTarget).find("input[type='file']").trigger("click");
  });
});

$(() => {
  $("body").append(
    $("<div class='dull-alert-container' id='alert-container'></div>")
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
  $(".dull-submit[data-type=\"submit\"]").attr("type", "submit");
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
  "dull-progress": (msg) => {
    var $bar = $(".dull-progress-output #" + msg.id);

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
  "dull-stream": (data) => {
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
  Shiny.addCustomMessageHandler("dull:popover", (msg) => {
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
  Shiny.addCustomMessageHandler("dull:modal", function(msg) {
    if (msg.close === true) {
      $(".modal").modal("hide");
      return true;
    }

    var $modal;

    if ($(".modal").length) {
      $modal = $(".modal");
    } else {
      $modal = $([
        "<div class='modal fade' tabindex=-1 role='dialog'>",
        "<div class='modal-dialog' role='document'>",
        "<div class='modal-content'>",
        "<div class='modal-header'>",
        "<h5 class='modal-title'></h5>",
        "<button type='button' class='close' data-dismiss='modal' aria-label='Close'>",
        "<span class='fa fa-times-rectangle'></span>",
        "</button>",
        "</div>",
        "<div class='container-fluid'>",
        "<div class='modal-body'></div>",
        "</div>",
        "</div>",
        "</div>",
        "</div>"
      ].join("\n"));

      $("body").append($modal);
    }


    $(".modal-title", $modal).html(msg.title);
    $(".modal-body", $modal).html(msg.body);

    if (msg.footer) {
      if (!$(".modal-footer", $modal).length) {
        $(".modal-content", $modal).append($("<div class='modal-footer'></div>"));
      }

      $(".modal-content", $modal).html(msg.footer);
    }

    $modal.modal();
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

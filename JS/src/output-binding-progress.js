$.extend(Shiny.progressHandlers, {
  "dull-progress": function(msg) {
    var $bar = $(".dull-progress-output #" + msg.id);

    $bar.attr("style", function(i, s) {
        return s.replace(/width: [0-9]+%/, "width: " + msg.value + "%");
      })
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

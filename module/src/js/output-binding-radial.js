var radialOutputBinding = new Shiny.OutputBinding();

$.extend(radialOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-radial-output[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    var dat = [30, 86, 168, 281, 303, 365];

    d3.select(".chart")
      .selectAll("div")
      .data(dat)
        .enter()
        .append("div")
        .style("width", function(d) { return d + "px"; })
        .text(function(d) { return d; });
  }
});

Shiny.outputBindings.register(radialOutputBinding, "dull.radialOutput");

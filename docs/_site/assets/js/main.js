$(function() {
  let initSlider = function(i, el) {
    let $el = $(el);
    let $input = $el.find("input[type='text']");

    $input.ionRangeSlider();

    let bgclasses = $el.attr("class")
        .split(/\s+/)
        .filter(c => /^bg-[a-z-]+|(lighten|darken)-[1234]/.test(c))
        .join(" ");

    if (bgclasses) {
      $el.find(".irs-slider,.irs-bar,.irs-bar-edge,.irs-to,.irs-from,.irs-single,.irs-slider")
        .addClass(bgclasses);
      $el.removeClass(bgclasses);
    }

    if ($input.data("no-fill")) {
      $el.find(".irs-bar,.irs-bar-edge").addClass("no-fill");
    }
  };

  $(document.querySelectorAll(".yonder-range")).each(initSlider);
});

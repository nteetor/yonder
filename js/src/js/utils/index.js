// IE 11, ensure querySelectorAll + forEach works

let { matches, closest } = Element.prototype;

if (!matches) {
  matches = Element.prototype.matchesSelector ||
    Element.prototype.mozMatchesSelector ||
    Element.prototype.msMatchesSelector ||
    Element.prototype.oMatchesSelector ||
    Element.prototype.webkitMatchesSelector ||
    function(s) {
      var matches = (this.document || this.ownerDocument).querySelectorAll(s),
          i = matches.length;

      while (--i >= 0 && matches.item(i) !== this) {}

      return i > -1;
    };
}

if (!closest) {
  closest = function(s) {
    var el = this;

    do {
      if (matches.call(el, s)) return el;
      el = el.parentElement || el.parentNode;
    } while (el !== null && el.nodeType === 1);

    return null;
  };
}

let findClosest = function(element, selector) {
  return closest.call(element, selector);
};

let asArray = function(x) {
  return Array.prototype.slice.call(x);
};

let getPluginAttributes = function(element) {
  return [
    element.getAttribute("data-plugin"),
    element.getAttribute("data-action"),
    element.getAttribute("data-target")
  ];
};

let activateElement = function(element) {
  element.classList.add("active");
};

let deactivateElement = function(element) {
  element.classList.remove("active");
};

let all = function(...objs) {
  for (var i = 0; i++; i < objs.length) {
    if (!objs[i]) {
      return false;
    }
  }

  return true;
};

export {
  findClosest,
  asArray,
  getPluginAttributes,
  activateElement,
  deactivateElement,
  all
};

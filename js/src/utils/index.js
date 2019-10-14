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

let matchesSelector = function(element, selector) {
  return matches.call(element, selector);
};

let asArray = function(x) {
  if (!x) {
    return [];
  } else if (typeof x === "object" && x.length) {
    return Array.prototype.slice.call(x);
  } else {
    return [x];
  }
};

let getPluginAttributes = function(element) {
  return [
    element.getAttribute("data-plugin"),
    element.getAttribute("data-action"),
    element.getAttribute("data-target")
  ];
};

let isNode = function(x) {
  return x && x.nodeType === 1;
};

let activateElements = function(elements, callback) {
  if (!elements) {
    return;
  }

  if (elements.length) {
    asArray(elements).forEach(e => activateElements(e));
  } else if (elements.classList) {
    elements.classList.add("active");

    if (typeof callback === "function") {
      callback(elements);
    }
  }
};

let deactivateElements = function(elements, callback) {
  if (!elements) {
    return;
  }

  if (elements.length) {
    asArray(elements).forEach(e => deactivateElements(e));
  } else if (elements.classList) {
    elements.classList.remove("active");

    if (typeof callback === "function") {
      callback(elements);
    }
  }
};

let filterElements = function(elements, values, getValue = x => x.value) {
  let targetValues = asArray(values).map(x => isNode(x) ? x : x.toString());

  elements = asArray(elements);
  let elementValues = elements.map(getValue);

  let foundElements = [];
  let foundValues = [];

  for (var i = 0; i < targetValues.length; i++) {
    let v = targetValues[i];
    let found = elements[isNode(v) ? elements.indexOf(v) : elementValues.indexOf(v)];

    if (found === undefined) {
      continue;
    }

    foundElements.push(found);
    foundValues.push(elementValues[i]);
  }

  return [foundElements, foundValues];
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
  matchesSelector,
  asArray,
  getPluginAttributes,
  isNode,
  activateElements,
  deactivateElements,
  filterElements,
  all
};

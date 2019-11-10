// IE 11, ensure querySelectorAll + forEach works

let { matches, closest } = Element.prototype

if (!matches) {
  matches = Element.prototype.matchesSelector ||
    Element.prototype.mozMatchesSelector ||
    Element.prototype.msMatchesSelector ||
    Element.prototype.oMatchesSelector ||
    Element.prototype.webkitMatchesSelector ||
    function(s) {
      var matches = (this.document || this.ownerDocument).querySelectorAll(s),
          i = matches.length

      while (--i >= 0 && matches.item(i) !== this) {}

      return i > -1
    }
}

if (!closest) {
  closest = function(s) {
    var el = this

    do {
      if (matches.call(el, s)) return el
      el = el.parentElement || el.parentNode
    } while (el !== null && el.nodeType === 1)

    return null
  }
}

let findClosest = function(element, selector) {
  return closest.call(element, selector)
}

let matchesSelector = function(element, selector) {
  return matches.call(element, selector)
}

let walk = function(x, f) {
  Array.prototype.forEach.call(x, f)
}

let asArray = function(x) {
  if (!x) {
    return []
  } else if (typeof x === "object" && x.length !== undefined) {
    return Array.prototype.slice.call(x)
  } else {
    return [x]
  }
}

let getPluginAttributes = function(element) {
  return [
    element.getAttribute("data-plugin"),
    element.getAttribute("data-action"),
    element.getAttribute("data-target")
  ]
}

let isNode = function(x) {
  return x && x.nodeType === 1
}

let activeElement = function(element) {
  return element.classList && element.classList.contains("active")
}

let disabledElement = function(element) {
  return element.classList &&
    element.classList.contains("disabled") &&
    element.hasAttribute("disabled")
}

let activateElements = function(elements, callback) {
  if (!elements) {
    return
  }

  if (elements.length) {
    asArray(elements).forEach(el => activateElements(el, callback))
  } else if (elements.classList && !disabledElement(elements)) {
    elements.classList.add("active")

    if (typeof callback === "function") {
      callback(elements)
    }
  }
}

let deactivateElements = function(elements, callback) {
  if (!elements) {
    return
  }

  if (elements.length) {
    asArray(elements).forEach(el => deactivateElements(el, callback))
  } else if (elements.classList && !disabledElement(elements)) {
    elements.classList.remove("active")

    if (typeof callback === "function") {
      callback(elements)
    }
  }
}

let toggleElements = function(elements, callback) {
  if (!elements) {
    return
  }

  if (elements.length) {
    asArray(elements).forEach(e => toggleElements(e, callback))
  } else if (elements.classList && !disabledElement(elements)) {
    let active = elements.classList.toggle("active")

    if (typeof callback === "function") {
      callback(elements, active)
    }
  }
}

let filterElements = function(elements, targets, getValue = x => x.value) {
  targets = asArray(targets)
  let targetValues = targets.map(x => isNode(x) ? getValue(x) : x.toString())

  elements = asArray(elements)
  let elementValues = elements.map(getValue)

  let foundElements = []
  let foundValues = []

  for (var i = 0; i < targetValues.length; i++) {
    let v = targetValues[i]
    let el = elements[elementValues.indexOf(v)]

    if (el) {
      foundElements.push(el)
      foundValues.push(v)
    }
  }

  return [foundElements, foundValues]
}

let all = function(...objs) {
  return objs.every(x => x)
}

export {
  findClosest,
  matchesSelector,
  walk,
  asArray,
  getPluginAttributes,
  isNode,
  activeElement,
  disabledElement,
  activateElements,
  deactivateElements,
  toggleElements,
  filterElements,
  all
}

import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import Store from "../data/store.js"
import {
  findClosest,
  getPluginAttributes
} from "../utils/index.js"

const NAME = "link"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-link"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  PLUGIN: "[data-plugin]"
}

const Event = {
  CLICK: `click.${ TYPE }`
}

class LinkInput extends Input {

  // fields ----

  static get TYPE() {
    return TYPE
  }

  // methods ----

  constructor(element) {
    super(element, TYPE)

    this._value = 0
  }

  value(x) {
    if (typeof x === "undefined") {
      return this._value
    }

    this._value = x
    this._callback()

    return this
  }

  content(html) {
    this._element.innerHTML = html
  }

  disable(values) {
    this._element.setAttribute("disabled", "")
  }

  enable() {
    this._element.removeAttribute("disabled")
  }

  // static ----

  static initialize(element) {
    super.initialize(element, TYPE, LinkInput)
  }

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static getValue(element) {
    let input = Store.getData(element, TYPE)

    if (!input) {
      return null
    }

    return input.value() === 0 ? null : input.value()
  }

  static subscribe(element, callback) {
    super.subscribe(element, callback, TYPE)
  }

  static unsubscribe(element) {
    super.unsubscribe(element, TYPE)
  }

  static receiveMessage(element, message) {
    super.receiveMessage(element, message, TYPE)
  }

  static ShinyInterface() {
    return { ...Input, ...LinkInput }
  }
}

// events ----

$(document).on(Event.CLICK, Selector.INPUT, (event) => {
  let link = findClosest(event.target, Selector.INPUT)
  let linkInput = Store.getData(link, TYPE)

  if (!linkInput) {
    return
  }

  linkInput.value(linkInput.value() + 1)
})

$(document).on(Event.CLICK, `${ Selector.INPUT }${ Selector.PLUGIN }`, (event) => {
  let link = findClosest(event.target, Selector.INPUT)
  let [plugin, action, target] = getPluginAttributes(link)

  if (!(plugin && action && target)) {
    return
  }

  if (plugin === "tab") {
    $(link).one("shown.bs.tab", (e) => link.classList.remove("active"))
  }

  $(link)[plugin](action)
})

export default LinkInput

if (Shiny) {
  Shiny.inputBindings.register(LinkInput.ShinyInterface(), TYPE)
}

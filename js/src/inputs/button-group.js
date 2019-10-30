import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import InputError from "../errors/input.js"
import Store from "../data/store.js"
import {
  asArray,
  findClosest,
  getPluginAttributes
} from "../utils/index.js"

const NAME = "buttongroup"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-button-group",
  CHILD: "btn",
  DISABLED: "disabled"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  PARENT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`,
  PLUGIN: "[data-plugin]"
}

const Event = {
  CLICK: `click.${ TYPE }`
}

class ButtonGroupInput extends Input {

  static get TYPE() {
    return TYPE
  }

  constructor(element) {
    super(element, TYPE)

    this._counter = 0
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
    let children = this._element.querySelectorAll(Selector.CHILD)

    asArray(children).forEach((btn) => {
      if (typeof values === "undefined" || values.indexOf(btn.value) > -1) {
        btn.setAttribute(ClassName.DISABLED, "")
        btn.setAttribute("aria-disabled", "true")
      }
    })
  }

  enable(values) {
    let children = this._element.querySelectorAll(Selector.CHILD)

    asArray(children).forEach((btn) => {
      if (typeof values === "undefined" || values.indexOf(btn.value) > -1) {
        btn.removeAttribute(ClassName.DISABLED)
        btn.setAttribute("aria-disabled", "false")
      }
    })
  }

  // static ----

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static initialize(element) {
    super.initialize(element, TYPE, ButtonGroupInput)
  }

  static getType(element) {
    return TYPE
  }

  static getValue(element) {
    let input = Store.getData(element, TYPE)

    if (!input) {
      return null
    }

    return { value: input.value(), counter: input._counter++ }
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
    return { ...Input, ...ButtonGroupInput }
  }
}

$(document).on(Event.CLICK, Selector.PARENT_CHILD, (event) => {
  const button = event.currentTarget
  const group = findClosest(button, Selector.INPUT)

  let input = Store.getData(group, TYPE)

  if (!input) {
    return
  }

  input.value(button.value)
})

$(document).on(Event.CLICK, `${ Selector.PARENT_CHILD }${ Selector.PLUGIN }`, (event) => {
  const button = event.currentTarget
  const [plugin, action, target] = getPluginAttributes(button)

  if (!plugin || !action || !target) {
    return
  }

  if (plugin === "tab") {
    $(button).one("shown.bs.tab", (e) => button.classList.remove("active"))
  }

  $(button)[plugin](action)
})

if (Shiny) {
  Shiny.inputBindings.register(ButtonGroupInput.ShinyInterface(), TYPE)
}

export default ButtonGroupInput

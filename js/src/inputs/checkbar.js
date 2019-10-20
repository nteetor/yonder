import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import Store from "../data/store.js"
import {
  findClosest,
  asArray,
  isNode,
  activeElement,
  activateElements,
  deactivateElements,
  toggleElements,
  filterElements
} from "../utils/index.js"

const NAME = "checkbar"
const TYPE = `yonder.${ TYPE }`

const ClassName = {
  INPUT: "yonder-checkbar",
  CHILD: "btn"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  PARENT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`
}

const Event = {
  CHANGE: `change.${ TYPE }`
}

class CheckbarInput extends Input {

  // methods ----

  constructor(element) {
    super(element, TYPE)
  }

  value(x) {
    if (typeof x === "undefined") {
      return this._value
    }

    this._value = x
    this._callback()

    return this
  }

  select(x) {
    let children = this._element.querySelectorAll(Selector.CHILD)

    let [targets, values]  = filterElements(children, x, child => child.children[0].value)

    deactivateElements(targets, target => {
      target.children[0].checked = false
    })

    if (targets.length) {
      activateElements(targets, target => {
        target.children[0].checked = true
      })

      this.value(values)
    }
  }

  toggle(x) {
    let children = this._element.querySelectorAll(Selector.CHILD)

    let [targets, _] = filterElements(children, x, child => child.children[0].value)

    if (targets.length) {
      toggleElements(targets, (target, active) => {
        target.children[0].checked = active
      })

      let remaining = asArray(children)
          .filter(activeElement)
          .map(child => child.children[0].value)

      this.value(remaining)
    }
  }

  // static

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static initialize(element) {
    super.initialize(element, TYPE, CheckbarInput)
  }

  static getValue(element) {
    return super.getValue(element, TYPE)
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
    return { ...Input, ...CheckbarInput }
  }
}

// events ----

$(document).on(Event.CHANGE, Selector.PARENT_CHILD, (event) => {
  let checkbar = findClosest(event.target, Selector.INPUT)
  let checkbarInput = Store.getData(checkbar, TYPE)

  if (!checkbarInput) {
    return
  }

  let button = findClosest(event.target, Selector.CHILD)

  checkbarInput.toggle(button)
})

export default CheckbarInput

if (Shiny) {
  Shiny.inputBindings.register(CheckbarInput.ShinyInterface(), TYPE)
}

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

const NAME = "checkbox"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-checkbox",
  CHILD: "custom-checkbox"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`
}

const Event = {
  CHANGE: `change.${ TYPE }`
}

class CheckboxInput extends Input {

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

    let [targets, values] = filterElements(children, x, child => child.children[0].value)

    deactivateElements(children, child => {
      child.children[0].checked = false
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
    super.initialize(element, TYPE, CheckboxInput)
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
    return { ...Input, ...CheckboxInput }
  }
}

// events ----

$(document).on(Event.CHANGE, Selector.INPUT_CHILD, (event) => {
  let checkbox = findClosest(event.target, Selector.INPUT)
  let checkboxInput = Store.getData(checkbox, TYPE)

  if (!checkboxInput) {
    return
  }

  let box = findClosest(event.target, Selector.CHILD)

  checkboxInput.toggle(box)
})

export default CheckboxInput

if (Shiny) {
  Shiny.inputBindings.register(CheckboxInput.ShinyInterface(), TYPE)
}

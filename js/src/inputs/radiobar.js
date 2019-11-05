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
  filterElements,
  getPluginAttributes,
  all
} from "../utils/index.js"

const NAME = "radiobar"
const TYPE = `yonder.${ TYPE }`

const ClassName = {
  INPUT: "yonder-radiobar",
  CHILD: "btn"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`
}

const Event = {
  CHANGE: `change.${ TYPE }`
}

class RadiobarInput extends Input {

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

    deactivateElements(children, target => {
      target.children[0].checked = false
    })

    if (targets.length) {
      activateElements(targets[0], target => {
        target.children[0].checked = true
      })

      this.value(values[0])
    }
  }

  // static

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static initialize(element) {
    super.initialize(element, TYPE, RadiobarInput)
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
    return { ...Input, ...RadiobarInput }
  }
}

// events ----

$(document).on(Event.CHANGE, Selector.INPUT_CHILD, (event) => {
  let radiobar = findClosest(event.target, Selector.INPUT)
  let radiobarInput = Store.getData(radiobar, TYPE)

  if (!radiobarInput) {
    return
  }

  let button = findClosest(event.target, Selector.CHILD)

  radiobarInput.select(button)
})

export default RadiobarInput

if (Shiny) {
  Shiny.inputBindings.register(RadiobarInput.ShinyInterface(), TYPE)
}

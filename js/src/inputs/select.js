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

const NAME = "select"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-select",
  CHILD: "dropdown-item"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`
}

const Event = {
  CLICK: `click.${ TYPE }`
}

class SelectInput extends Input {

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

    let [targets, values] = filterElements(children, x)

    deactivateElements(children)

    if (targets.length) {
      activateElements(targets[0])

      this.value(values[0])
    }

    return targets[0]
  }

  // static ----

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static initialize(element) {
    super.initialize(element, TYPE, SelectInput)
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
    return { ...Input, ...SelectInput }
  }

}

// events ----

$(document).on(Event.CLICK, Selector.INPUT_CHILD, (event) => {
  let select = findClosest(event.target, Selector.INPUT)
  let selectInput = Store.getData(select, TYPE)

  if (!selectInput) {
    return
  }

  let item = findClosest(event.target, Selector.CHILD)

  selectInput.select(item)
})

export default SelectInput

if (Shiny) {
  Shiny.inputBindings.register(SelectInput.ShinyInterface(), TYPE)
}

import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import Store from "../data/store.js"
import {
  findClosest
} from "../utils/index.js"

const NAME = "range"
const TYPE = `yonder.${ NAME }`

const POLICY = "debounce"
const DELAY = 500

const ClassName = {
  INPUT: "yonder-range",
  CHILD: "custom-range"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`
}

const Event = {
  INPUT: `input.${ TYPE }`
}

class RangeInput extends Input {

  // methods ----

  constructor(element) {
    super(element, TYPE)

    this._debounce = true
  }

  value(x) {
    if (arguments.length === 0) {
      return this._value
    }

    this._value = x
    this._callback()

    return this
  }

  // static ----

  static get POLICY() {
    return POLICY
  }

  static get DELAY() {
    return DELAY
  }

  static initialize(element) {
    super.initialize(element, TYPE, RangeInput)
  }

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static getValue(element) {
    return super.getValue(element, TYPE)
  }

  static getRatePolicy() {
    return {
      policy: RangeInput.POLICY,
      delay: RangeInput.DELAY
    }
  }

  static subscribe(element, callback) {
    super.subscribe(element, callback, TYPE)
  }

  static unsubscribe(element) {
    super.unsubscribe(element, TYPE)
  }

  static ShinyInterface() {
    return { ...Input, ...RangeInput }
  }

}

// events ----

$(document).on(Event.INPUT, Selector.INPUT_CHILD, (event) => {
  let range = findClosest(event.target, Selector.INPUT)
  let rangeInput = Store.getData(range, TYPE)

  if (!rangeInput) {
    return
  }

  let child = findClosest(event.target, Selector.CHILD)
  let value = child.valueAsNumber

  if (Number.isNaN(value) || value === undefined) {
    return
  }

  rangeInput.value(value)
})

export default RangeInput

// interfaces ----

if (Shiny) {
  Shiny.inputBindings.register(RangeInput.ShinyInterface(), TYPE)
}

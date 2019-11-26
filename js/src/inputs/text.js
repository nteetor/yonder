import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import Store from "../data/store.js"
import {
  findClosest,
  asArray
} from "../utils/index.js"

const NAME = "text"
const TYPE = `yonder.${ NAME }`

const POLICY = "debounce"
const DELAY = 450

const ClassName = {
  INPUT: "yonder-text",
  CHILD: "form-control"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`
}

const Event = {
  // CHANGE: `change.${ TYPE }`
  INPUT: `input.${ TYPE }`
}

class TextInput extends Input {

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
    super.initialize(element, TYPE, TextInput)
  }

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static getValue(element) {
    return super.getValue(element, TYPE)
  }

  static getRatePolicy() {
    return {
      policy: TextInput.POLICY,
      delay: TextInput.DELAY
    }
  }

  static subscribe(element, callback) {
    super.subscribe(element, callback, TYPE)
  }

  static unsubscribe(element) {
    super.unsubscribe(element, TYPE)
  }

  static ShinyInterface() {
    return { ...Input, ...TextInput }
  }

}

// events ----

$(document).on(Event.INPUT, Selector.INPUT_CHILD, (event) => {
  let text = findClosest(event.target, Selector.INPUT)
  let textInput = Store.getData(text, TYPE)

  if (!textInput) {
    return
  }

  let child = event.target

  textInput.value(child.value)
})

export default TextInput

if (Shiny) {
  Shiny.inputBindings.register(TextInput.ShinyInterface(), TYPE)
}

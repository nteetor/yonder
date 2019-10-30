import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import InputError from "../errors/input.js"
import Store from "../data/store.js"
import {
  findClosest,
  asArray,
  getPluginAttributes
} from "../utils/index.js"

const NAME = "form"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-form",
  CHILD: "shiny-bound-input",
  SUBMIT: "yonder-form-submit"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`,
  SUBMIT: `.${ ClassName.SUBMIT }`
}

const Event = {
  CLICK: `click.${ TYPE }`,
  CHANGE: `shiny:inputchanged.${ TYPE }`,
  BOUND: `shiny:bound.${ TYPE }`,
  UNBOUND: `shiny:unbound.${ TYPE }`
}

class FormInput extends Input {

  // methods ----

  constructor(element) {
    super(element, TYPE, FormInput)

    this._map = {}
  }

  value(x) {
    if (typeof x === "undefined") {
      return this._value
    }

    this._value = x
    this._callback()

    return this
  }

  put(key, value) {
    this._map[key] = value

    return this
  }

  delete(key) {
    let value = this._map[key]

    delete this._map[key]

    return value
  }

  fields() {
    return Object.keys(this._map)
  }

  entries() {
    return this.fields().map(key => [key, this._map[key]])
  }

  // static ----

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static initialize(element) {
    super.initialize(element, TYPE, FormInput)
  }

  static getType(element) {
    return TYPE
  }

  static getValue(element) {
    super.getValue(element, TYPE)
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
    return { ...Input, ...FormInput }
  }
}

// events ----

$(document).on(Event.CLICK, Selector.SUBMIT, (event) => {
  let submitButton = findClosest(event.target, Selector.SUBMIT)
  let form = findClosest(submitButton, Selector.INPUT)

  if (!form) {
    return
  }

  let formInput = Store.getData(form, TYPE)

  if (!formInput) {
    return
  }

  formInput.value(submitButton.value)

  if (Shiny) {
    formInput.entries().forEach(([key, value]) => {
      Shiny.setInputValue(key, value, { priority: "event" })
    })
  }
})

$(document).on(Event.BOUND, Selector.INPUT_CHILD, (event) => {
  let child = event.target

  let form = findClosest(child, Selector.INPUT)
  let formInput = Store.getData(form, TYPE)

  if (!formInput) {
    return
  }

  formInput.put(child.id, null)
})

$(document).on(Event.UNBOUND, Selector.INPUT_CHILD, (event) => {
  let child = event.target

  let form = findClosest(child, Selector.INPUT)
  let formInput = Store.getData(form, TYPE)

  if (!formInput) {
    return
  }

  formInput.delete(child.id)
})

$(document).on(Event.CHANGE, Selector.INPUT_CHILD, (event) => {
  if (event.priority && event.priority === "event") {
    return
  }

  let child = findClosest(event.target, Selector.CHILD)

  let form = findClosest(child, Selector.INPUT)
  let formInput = Store.getData(form, TYPE)

  if (!formInput) {
    return
  }

  formInput.put(child.id, event.value)
})

if (Shiny) {
  Shiny.inputBindings.register(FormInput.ShinyInterface(), TYPE)
}

export default FormInput

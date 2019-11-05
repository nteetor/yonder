import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import Store from "../data/store.js"
import {
  findClosest,
  filterElements,
  deactivateElements,
  activateElements,
  getPluginAttributes,
  all
} from "../utils/index.js"

const NAME = "listgroup"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-list-group",
  CHILD: "list-group-item-action"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`,
  PLUGIN: "[data-plugin]"
}

const Event = {
  CLICK: `click.${ TYPE }`
}

class ListGroupInput extends Input {

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

    return targets
  }

  // static ----

  static initialize(element) {
    super.initialize(element, TYPE, ListGroupInput)
  }

  static find(scope) {
    return super.find(scope, Selector.INPUT)
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
    return { ...Input, ...ListGroupInput }
  }
}

// events ----

$(document).on(Event.CLICK, `${ Selector.INPUT_CHILD }${ Selector.PLUGIN }`, (event) => {
  let listItem = findClosest(event.target, Selector.CHILD)

  let [plugin, action, target] = getPluginAttributes(listItem)

  if (!all(plugin, action, target)) {
    return
  }

  $(listItem)[plugin](action)
})

$(document).on(Event.CLICK, Selector.INPUT_CHILD, (event) => {

  let listGroup = findClosest(event.target, Selector.INPUT)
  let listGroupInput = Store.getData(listGroup, TYPE)

  if (!listGroupInput) {
    return
  }

  let listItem = findClosest(event.target, Selector.CHILD)

  listGroupInput.select(listItem)
})

export default ListGroupInput

if (Shiny) {
  Shiny.inputBindings.register(ListGroupInput.ShinyInterface(), TYPE)
}

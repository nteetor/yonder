import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import Store from "../data/store.js"
import {
  findClosest,
  walk,
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
  CHILD: "dropdown-item",
  TOGGLE: "custom-select",
  MENU: "dropdown-menu",
  ACTIVE: "active",
  MISMATCHED: "mismatched"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  MISMATCHED: `${ ClassName.MISMATCHED }`,
  TOGGLE: `.${ ClassName.TOGGLE }`,
  INPUT_INACTIVE_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }:not(.${ ClassName.ACTIVE })`,
  INPUT_TOGGLE: `.${ ClassName.INPUT } .${ ClassName.TOGGLE }`,
  CHILD_MISMATCHED: `.${ ClassName.CHILD }.${ ClassName.MISMATCHED }`,
  MENU: `.${ ClassName.MENU }`,
  ACTIVE: `.${ ClassName.ACTIVE }`
}

const Event = {
  CLICK: `click.${ TYPE }`,
  CHANGE: `change.${ TYPE }`,
  INPUT: `input.${ TYPE }`,
  MENU_CLOSE: `hide.bs.dropdown.${ TYPE }`,
  MENU_OPEN: `show.bs.dropdown.${ TYPE }`
}

class SelectInput extends Input {

  // methods ----

  constructor(element) {
    super(element, TYPE)

    this._$toggle = $(this._element.querySelector(Selector.TOGGLE))
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

    this._$toggle[0].value = values[0]
    this.filter(values[0])

    return targets[0]
  }

  filter(x) {
    if (!x) {
      let children = this._element.querySelectorAll(Selector.CHILD_MISMATCHED)

      walk(children, (child) => child.classList.remove(ClassName.MISMATCHED))

      return this
    }

    let children = this._element.querySelectorAll(Selector.CHILD)

    x = x.toLowerCase()

    walk(children, (child) => {
      if (child.innerText.toLowerCase().indexOf(x) === -1) {
        child.classList.add(ClassName.MISMATCHED)
      } else {
        child.classList.remove(ClassName.MISMATCHED)
      }
    })


    this._$toggle.dropdown("update")

    return this
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

$(document).on(Event.CLICK, Selector.INPUT_INACTIVE_CHILD, (event) => {
  let select = findClosest(event.target, Selector.INPUT)
  let selectInput = Store.getData(select, TYPE)

  if (!selectInput) {
    return
  }

  let item = findClosest(event.target, Selector.CHILD)

  selectInput.select(item)
})

$(document).on(Event.INPUT, Selector.INPUT_TOGGLE, (event) => {
  let select = findClosest(event.target, Selector.INPUT)
  let selectInput = Store.getData(select, TYPE)

  if (!selectInput) {
    return
  }

  let toggle = findClosest(event.target, Selector.TOGGLE)

  selectInput.filter(toggle.value)
})

$(document).on(Event.MENU_OPEN, Selector.INPUT, (event) => {
  let select = findClosest(event.target, Selector.INPUT)
  let toggle = select.querySelector(Selector.TOGGLE)

  toggle.focus()
  toggle.select()

  toggle.classList.add("disabled")
})

$(document).on(Event.MENU_CLOSE, Selector.INPUT, (event) => {
  let select = findClosest(event.target, Selector.INPUT)
  let toggle = select.querySelector(Selector.TOGGLE)

  toggle.classList.remove("disabled")

  let selectInput = Store.getData(select, TYPE)

  if (!selectInput) {
    return
  }

  toggle.value = selectInput.value()
  selectInput.filter(toggle.value)
})

export default SelectInput

if (Shiny) {
  Shiny.inputBindings.register(SelectInput.ShinyInterface(), TYPE)
}

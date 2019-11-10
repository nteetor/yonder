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

const NAME = "groupselect"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-group-select",
  CHILD: "custom-select",
  LEFT_ADDONS: "input-group-prepend",
  RIGHT_ADDONS: "input-group-append",
  ADDON_BUTTON: "btn",
  ADDON_TEXT: "input-group-text"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`,
  LEFT_ADDONS: `.${ ClassName.LEFT_ADDONS }`,
  RIGHT_ADDONS: `.${ ClassName.RIGHT_ADDONS }`,
  ADDON_TEXT: `.${ ClassName.ADDON_TEXT }`
}

const Event = {
  CHANGE: `change.${ TYPE }`
}

class GroupSelectInput extends Input {

  // methods ----

  constructor(element) {
    super(element, TYPE)

    this._prefix = this._addon(Selector.LEFT_ADDONS) || ""
    this._suffix = this._addon(Selector.RIGHT_ADDONS) || ""
  }

  value(x) {
    if (typeof x === "undefined") {
      return this._value === null ? null : this._prefix + this._value + this._suffix
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

  prefix(x) {
    if (typeof x === "undefined") {
      return this._prefix
    }

    x = asArray(x)
    this._prefix = x.join("")

    let leftAddons = this._element.querySelector(Selector.LEFT_ADDONS)

    if (!x.length) {
      if (leftAddons) {
        this._element.removeChild(leftAddons)
      }

      return this
    }

    if (!leftAddons) {
      let newLeft = document.createElement("div")
      newLeft.classList.add(ClassName.LEFT_ADDONS)

      this._element.insertAdjacentElement("afterbegin", newLeft)

      leftAddons = newLeft
    } else {
      walk(leftAddons.querySelectorAll(Selector.ADDON_TEXT), (el) => {
        leftAddons.removeChild(el)
      })
    }

    x.forEach(text => {
      let newAddon = document.createElement("div")

      newAddon.classList.add(ClassName.ADDON_TEXT)
      newAddon.innerText = text

      leftAddons.insertAdjacentElement("beforeend", newAddon)
    })

    return this
  }

  suffix(x) {
    if (typeof x === "undefined") {
      return this._suffix
    }

    x = asArray(x)
    this._suffix = x.join(" ")

    let rightAddons = this._element.querySelector(Selector.RIGHT_ADDONS)

    if (!x.length) {
      if (rightAddons) {
        this._element.removeChild(rightAddons)
      }

      return this
    }

    if (!rightAddons) {
      let newRight = document.createElement("div")

      newRight.classList.add(ClassName.RIGHT_ADDONS)
      this._element.insertAdjacentElement("beforeend", newRight)

      rightAddons = newRight
    } else {
      walk(rightAddons.querySelectorAll(Selector.ADDON_TEXT), (el) => {
        rightAddons.removeChild(el)
      })
    }

    x.forEach(text => {
      let newAddon = document.createElement("div")

      newAddon.classList.add(ClassName.ADDON_TEXT)
      newAddon.innerText = text

      rightAddons.insertAdjacentElement("afterbegin", newAddon)
    })

    return this
  }

  // private ----

  _addon(selector) {
    let parent = this._element.querySelector(selector)

    if (!parent) {
      return null
    }

    return asArray(parent.querySelectorAll(Selector.ADDON_TEXT))
      .map(el => el.innerText)
      .join("")
  }

  // static ----

  static find(scope) {
    return super.find(scope, Selector.INPUT)
  }

  static initialize(element) {
    super.initialize(element, TYPE, GroupSelectInput)
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
    return { ...Input, ...GroupSelectInput }
  }

}

// events ----

$(document).on(Event.CHANGE, Selector.INPUT_CHILD, (event) => {
  let group = findClosest(event.target, Selector.INPUT)
  let groupInput = Store.getData(group, TYPE)

  if (!groupInput) {
    return
  }

  let select = findClosest(event.target, Selector.CHILD)

  groupInput.value(select.value)
})

export default GroupSelectInput

if (Shiny) {
  Shiny.inputBindings.register(GroupSelectInput.ShinyInterface(), TYPE)
}

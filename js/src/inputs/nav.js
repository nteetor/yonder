import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import Store from "../data/store.js"
import MenuInput from "./menu.js"
import {
  findClosest,
  asArray,
  getPluginAttributes,
  isNode,
  activateElements,
  deactivateElements,
  filterElements,
  all
} from "../utils/index.js"

const NAME = "nav"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-nav",
  CHILD: "nav-link",
  ITEM: "nav-item"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  PARENT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`,
  ACTIVE: ".active",
  DISABLED: ".disabled",
  PLUGIN: "[data-plugin]",
  NAV_ITEM: `.${ ClassName.ITEM }`,
  MENU: MenuInput.Selector.INPUT,
  MENU_TOGGLE: MenuInput.Selector.TOGGLE,
  MENU_ITEM: MenuInput.Selector.CHILD,
}

const Event = {
  CLICK: `click.${ TYPE }`
}

class NavInput extends Input {

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

    deactivateElements(children, child => {
      if (targets.indexOf(child) > -1) {
        return
      }

      let menuInput = Store.getData(child.parentNode, MenuInput.TYPE)

      if (!menuInput) {
        return
      }

      menuInput.select(null)
    })

    if (targets.length) {
      activateElements(targets[0])
      this.value(values[0])
    }
  }

  disable(values) {

  }

  enable(values) {

  }

  // static ----

  static initialize(element) {
    super.initialize(element, TYPE, NavInput)
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
    return { ...Input, ...NavInput }
  }
}

// events ----

$(document).on(Event.CLICK, `${ Selector.PARENT_CHILD }:not(${ Selector.MENU_TOGGLE })`, (event) => {
  let nav = findClosest(event.target, Selector.INPUT)
  let navInput = Store.getData(nav, TYPE)

  if (!navInput) {
    return
  }

  let button = findClosest(event.target, Selector.CHILD)

  navInput.select(button)
})

$(document).on(Event.CLICK, `${ Selector.PARENT_CHILD }${ Selector.PLUGIN }`, (event) => {
  let link = findClosest(event.target, Selector.CHILD)
  let [plugin, action, target] = getPluginAttributes(link)

  if (!all(plugin, action, target)) {
    return
  }

  // ensure we can select or activate a nav link that may already be active
  deactivateElements(link)

  $(link)[plugin](action)
})

$(document).on(Event.CLICK, `${ Selector.INPUT } ${ Selector.MENU_ITEM }`, (event) => {
  let nav = findClosest(event.target, Selector.INPUT)
  let navInput = Store.getData(nav, TYPE)

  if (!navInput) {
    return
  }

  let item = findClosest(event.target, Selector.NAV_ITEM)
  let link = item.querySelector(Selector.CHILD)

  navInput.select(link)

  let menu = findClosest(event.target, Selector.MENU)

  if (!menu.id) {
    let menuItem = findClosest(event.target, Selector.MENU_ITEM)
    navInput.value(menuItem.value)
  }
})

// shiny ----

// If shiny is present register the input's shiny interface with shiny's
// input bindings.
if (Shiny) {
  Shiny.inputBindings.register(NavInput.ShinyInterface(), TYPE)
}

export default NavInput

if (Shiny) {
  Shiny.addCustomMessageHandler("yonder:pane", (msg) => {
    let _show = function(pane) {
      if (pane === null || pane.classList.contains("show")) {
        return
      }

      if (!pane.parentElement.classList.contains("tab-content")) {
        console.warn(`nav pane ${ pane.id } is missing a nav content parent element`)
        return
      }

      let previous = pane.parentElement.querySelector(".active")

      const complete = () => {
        const hiddenEvent = $.Event("hidden.bs.tab", {
          relatedTarget: pane
        })

        const shownEvent = $.Event("shown.bs.tab", {
          relatedTarget: previous
        })

        $(previous).trigger(hiddenEvent)
        $(pane).trigger(shownEvent)
      }

      bootstrap.Tab.prototype._activate(pane, pane.parentElement, complete)
    }

    let _hide = function(pane) {
      if (pane === null || !pane.classList.contains("show")) {
        return
      }

      if (!pane.parentElement.classList.contains("tab-content")) {
        console.warn(`nav pane ${ pane.id } is missing a nav content parent element`)
        return
      }

      const complete = () => {
        const hiddenEvent = $.Event("hidden.bs.tab", {
          relatedTarget: pane
        })

        $(pane).trigger(hiddenEvent)
      }

      let dummy = document.createElement("div")

      bootstrap.Tab.prototype._activate(dummy, pane.parentElement, complete)
    }

    if (msg.type === undefined ||
        msg.data === undefined ||
        msg.data.target === undefined) {
      return
    }

    let target = document.getElementById(msg.data.target)

    if (target === null) {
      return
    }

    if (msg.type === "show") {
      _show(target)
    } else if (msg.type === "hide") {
      _hide(target)
    }
  })
}

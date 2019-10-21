import $ from "jQuery"
import Shiny from "Shiny"

import Input from "./input.js"
import Store from "../data/store.js"
import {
  findClosest,
  asArray,
  isNode,
  activateElements,
  deactivateElements,
  filterElements
} from "../utils/index.js"

const NAME = "file"
const TYPE = `yonder.${ NAME }`

const ClassName = {
  INPUT: "yonder-file",
  PROGRESS: "progress"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  PROGRESS: `.${ ClassName.PROGRESS }`
}

const Event = {
  DRAGOVER: `dragover.${ TYPE }`,
  DRAGCENTER: `dragcenter.${ TYPE }`,
  DROP: `drop.${ TYPE }`,
  CHANGE: `change.${ TYPE }`
}

class FileInput extends Input {

  // methods ----

  constructor(element) {
    super(element, TYPE)
  }

  value() {
    return null
  }

  upload() {
    let files = this._element.files

    return files
  }

  // static ----

  static initialize(element) {
    super.initialize(element, TYPE, FileInput)
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

  static ShinyInterface() {
    return { ...Input, ...FileInput }
  }

}

// events ----

$(document).on(Event.DRAGOVER, Selector.INPUT, (event) => {
  event.stopPropagation()
  event.preventDefault()
})

$(document).on(Event.DRAGOVER, Selector.INPUT, (event) => {
  event.stopPropagation()
  event.preventDefault()
})

$(document).on(Event.DROP, Selector.INPUT, (event) => {
  event.stopPropagation()
  event.preventDefault()

  let el = findClosest(event.target, Selector.INPUT)
  let fileInput = Store.getData(el, TYPE)

  if (!fileInput) {
    return
  }

  // upload
})

$(document).on(Event.CHANGE, Selector.INPUT, (event) => {
  console.log("change")
})

export default FileInput

if (Shiny) {
  Shiny.inputBindings.register(FileInput.ShinyInterface(), TYPE)
}

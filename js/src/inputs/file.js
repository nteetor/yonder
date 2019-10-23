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
  PROGRESS: "progress",
  PROGRESS_BAR: "progress-bar",
  PROGRESS_ANIMATED: "progress-bar-animated"
}

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  PROGRESS: `.${ ClassName.PROGRESS }`,
  PROGRESS_BAR: `.${ ClassName.PROGRESS } .${ ClassName.PROGRESS_BAR }`
}

const Event = {
  DRAGENTER: `dragenter.${ TYPE }`,
  DRAGOVER: `dragover.${ TYPE }`,
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
    let files = this._element.children[0].files

    if (!files.length) {
      return
    }

    let fileInfo = files.map(file => {
      let {name, size, type} = file;

      return { name, size, type }
    });

    let progress = this._element.querySelector(Selector.PROGRESS);

    let post = function(file, uri, id) {

      let req = new XMLHttpRequest()

      if (progress) {
        req.addEventListener("loadstart", (event) => {
          progress.classList.add(ClassName.PROGRESS_ANIMATED)
        })

        req.addEventListener("progress", (event) => {
          progress.style.width = `${ event.loaded / event.total }%`
        })

        req.addEventListener("loadend", (event) => {
          progress.classList.remove(ClassName.PROGRESS_ANIMATED)
        })
      }

      req.open()
    }


    Shiny.shinyapp.makeRequest("uploadInit", [fileInfo], (res) => {
      for (let i = 0; i < files.length; i++) {
        post(files[i], res.updloadUrl, res.jobId);
      }
    })
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

$(document).on(Event.DRAGENTER, Selector.INPUT, (event) => {
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

  el.children[0].files = event.originalEvent.dataTransfer.files

  fileInput.upload()
})

$(document).on(Event.CHANGE, Selector.INPUT, (event) => {
  let el = findClosest(event.target, Selector.INPUT)
  let fileInput = Store.getData(el, TYPE)

  if (!fileInput) {
    return
  }

  fileInput.upload()
})

export default FileInput

if (Shiny) {
  Shiny.inputBindings.register(FileInput.ShinyInterface(), TYPE)
}

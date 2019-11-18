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
  PROGRESS_STRIPED: "progress-bar-striped",
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
    let files = asArray(this._element.children[0].files)

    if (!files.length) {
      return
    }

    let fileInfo = files.map(file => {
      let {name, size, type} = file

      return { name, size, type }
    })

    let progress = this._element.querySelector(Selector.PROGRESS)

    files.forEach((file) => {
      let bar = document.createElement("div")
      bar.classList.add(ClassName.PROGRESS_BAR)
      bar.classList.add(ClassName.PROGRESS_STRIPED)
      bar.innerText = file.name
      progress.appendChild(bar)
    })

    Shiny.shinyapp.makeRequest("uploadInit", [fileInfo], (res) => {
      let completed = 0

      for (let i = 0; i < files.length; i++) {
        let file = files[i]
        let bar = progress.children[i]
        let req = new XMLHttpRequest()

        req.addEventListener("loadstart", (event) => {
          bar.classList.add(ClassName.PROGRESS_ANIMATED)
        })

        req.upload.addEventListener("progress", (event) => {
          bar.style.width = `${ Math.floor(event.loaded / event.total * 100 / files.length) }%`
        })

        req.addEventListener("loadend", (event) => {
          bar.style.width = `${ Math.floor(100 / files.length) }%`
          bar.classList.remove(ClassName.PROGRESS_ANIMATED)

          completed++

          if (completed === files.length) {
            console.log(res.jobId)
            Shiny.shinyapp.makeRequest("uploadEnd", [res.jobId, this._element.id], () => null, () => null)
          }
        })

        req.open("POST", res.uploadUrl, true)
        req.setRequestHeader("Content-Type", "application/octet-stream")
        req.send(file)
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

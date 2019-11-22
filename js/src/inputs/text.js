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
const DELAY = 500

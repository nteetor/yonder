import $ from "jQuery";
import Shiny from "Shiny";

import Input from "./input.js";
import Store from "../data/store.js";
import {
  findClosest,
  asArray,
  isNode,
  activateElements,
  deactivateElements,
  filterElements
} from "../utils/index.js";

const NAME = "file";
const TYPE = `yonder.${ NAME }`;

const ClassName = {
  INPUT: "yonder-file",
  PROGRESS: "progress"
};

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  PROGRESS: `.${ ClassName.PROGRESS }`
};

class FileInput extends Input {

  // methods ----

  constructor(element) {
    super(element, TYPE)
  }

};

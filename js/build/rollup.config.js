import babel from "rollup-plugin-babel";
import babelrc from "./babel.config.js";

import { terser } from "rollup-plugin-terser";

export default {
  input: "src/js/yonder.js",
  output: {
    file: "dist/js/yonder.js",
    format: "umd",
    sourcemap: "inline",
    name: "yonder",
    globals: {
      "Shiny": "Shiny",
      "jQuery": "$"
    }
  },
  external: [
    "Shiny",
    "jQuery",
  ],
  plugins: [
    babel({
      ...babelrc
    })
  ]
};

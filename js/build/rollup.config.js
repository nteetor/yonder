import babel from "rollup-plugin-babel";
import babelrc from "./babel.config.js";

import { terser } from "rollup-plugin-terser";

export default {
  input: "src/yonder.js",
  output: {
    file: "dist/yonder.js",
    format: "umd",
    sourcemap: "inline",
    name: "yonder"
  },
  plugins: [
    babel({
      ...babelrc
    })
  ]
};

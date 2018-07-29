import babel from "rollup-plugin-babel";
import { terser } from "rollup-plugin-terser";

export default {
  input: "src/js/yonder.js",
  output: {
    file: "dist/js/yonder.min.js",
    format: "iife",
    sourcemap: "inline",
    name: "yonder"
  },
  plugins: [
    babel({
      exclude: "node_modules/**"
    }),
    terser({
      mangle: true
    })
  ]
}

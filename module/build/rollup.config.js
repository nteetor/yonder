import babel from "rollup-plugin-babel";
import { terser } from "rollup-plugin-terser";

export default {
  input: "src/js/dull.js",
  output: {
    file: "dist/js/dull.min.js",
    format: "iife",
    sourcemap: "inline",
    name: "dull"
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

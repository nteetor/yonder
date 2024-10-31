import { babel } from "@rollup/plugin-babel";

// import { terser } from "rollup-plugin-terser";

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
      exclude: "node_modules/**",
      babelHelpers: "bundled"
    })
  ]
};

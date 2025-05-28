import path from 'node:path'
import { fileURLToPath } from 'node:url'
import { babel } from "@rollup/plugin-babel"
import banner from './banner.mjs'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

let destFile = 'bootstrap.esm'

export default {
  input: path.resolve(__dirname, '../src/js/yonder.js'),
  output: {
    banner: banner(),
    file: path.resolve(__dirname, '../dist/js/yonder.js'),
    format: 'esm',
    generatedCode: 'es2015'
  },
  plugins: [
    babel({
      exclude: 'node_modules/**',
      babelHelpers: 'bundled'
    })
  ]
}

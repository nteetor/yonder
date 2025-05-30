import path from 'node:path'
import { fileURLToPath } from 'node:url'
import { babel } from "@rollup/plugin-babel"
import banner from './banner.mjs'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

export default {
  input: path.resolve(__dirname, '../js/bsides.js'),
  output: {
    name: 'bsides',
    banner: banner(),
    file: path.resolve(__dirname, '../dist/js/bsides.js'),
    format: 'umd',
    generatedCode: 'es2015',
    globals: {
      jquery: '$'
    }
  },
  external: [
    'jquery'
  ],
  plugins: [
    babel({
      exclude: 'node_modules/**',
      babelHelpers: 'bundled'
    })
  ]
}

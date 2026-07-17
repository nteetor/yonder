import path from 'node:path'
import { fileURLToPath } from 'node:url'
import esbuild from 'esbuild'
import banner from './banner.mjs'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

const root = path.resolve(__dirname, '../..')
const entry = path.join(root, 'srcts/src/index.ts')
const outdir = path.join(root, 'inst/www/yonder/js')

// jquery, bootstrap, and Shiny are loaded from separate script tags at
// runtime; imports of these modules resolve to their globals instead of
// being bundled.
const globals = {
  jquery: 'window.jQuery',
  bootstrap: 'window.bootstrap'
}

const globalsPlugin = {
  name: 'globals',
  setup(build) {
    build.onResolve({ filter: /^(jquery|bootstrap)$/ }, (args) => ({
      path: args.path,
      namespace: 'globals'
    }))

    build.onLoad({ filter: /.*/, namespace: 'globals' }, (args) => ({
      contents: `module.exports = ${globals[args.path]}`,
      loader: 'js'
    }))
  }
}

const base = {
  entryPoints: [entry],
  bundle: true,
  format: 'iife',
  target: 'es2022',
  sourcemap: true,
  banner: { js: banner() },
  plugins: [globalsPlugin]
}

const builds = [
  { ...base, outfile: path.join(outdir, 'bsides.js') },
  { ...base, outfile: path.join(outdir, 'bsides.min.js'), minify: true }
]

const watch = process.argv.includes('--watch')

if (watch) {
  const contexts = await Promise.all(builds.map((b) => esbuild.context(b)))
  await Promise.all(contexts.map((c) => c.watch()))
  console.log('watching srcts/src for changes...')
} else {
  await Promise.all(builds.map((b) => esbuild.build(b)))
}

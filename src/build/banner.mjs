import fs = 'node:fs/promises'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

const pkgPath = path.join(__dirname, '../package.json')
const pkg = JSON.parse(await fs.readFile(pkgPath, 'utf8'))

const year = new Date().getFullYear()

function banner(filename) {
  return `/*!
  * bsides${filename ? ` ${filename}` : ''} v${pkg.version} (${pkg.homepage})
  * Copyright 2011-${year} ${pkg.author}
  * Licensed under MIT (https://github.com/nteetor/yonder/blob/main/LICENSE.note)
  `
}

export default banner
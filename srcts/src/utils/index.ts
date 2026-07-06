import type InputBinding from '../bindings/inputs/input'

const pkg = {
  prefix: 'bsides'
}

interface InputBindingConstructor {
  new (): InputBinding
  readonly type: string
}

function addCustomMessageHandler(
  type: string,
  handler: (data: any) => void | Promise<void>
): void {
  if (window.Shiny) {
    window.Shiny.addCustomMessageHandler(`${pkg.prefix}:${type}`, handler)
  }
}

function initialize(callback: () => void): void {
  if (document.readyState === 'complete') {
    callback()
  } else {
    document.addEventListener('DOMContentLoaded', callback)
  }
}

function registerBinding(binding: InputBindingConstructor): void {
  if (window.Shiny) {
    window.Shiny
      .inputBindings
      .register(new binding(), `${pkg.prefix}.${binding.type}`)
  }
}

export {
  pkg,
  initialize,
  registerBinding,
  addCustomMessageHandler
}

export type { InputBindingConstructor }

const pkg = {
  prefix: 'bsides'
}

function addCustomMessageHandler(type, handler) {
  if (window.Shiny) {
    Shiny.addCustomMessageHandler(`${pkg.prefix}:${type}`, handler)
  }
}

function initialize(callback) {
  if (document.readyState === 'complete') {
    callback()
  } else {
    document.addEventListener('DOMContentLoaded', callback)
  }
}

function registerBinding(binding) {
  if (window.Shiny) {
    Shiny
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
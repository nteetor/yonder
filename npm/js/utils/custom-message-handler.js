export default function addCustomMessageHandler(type, handler) {
  if (window.Shiny) {
    Shiny.addCustomMessageHandler(`bsides:${type}`, handler)
  }
}
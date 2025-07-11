export default function registerInput(inputBindingClass) {
  if (window.Shiny) {
    Shiny
      .inputBindings
      .register(new inputBindingClass(), inputBindingClass.type)
  }
}

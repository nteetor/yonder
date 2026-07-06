// Minimal declarations for the globals Shiny provides at runtime. Shiny is
// loaded from a separate script tag, so only the pieces bsides touches are
// declared here.

interface ShinyRenderContent {
  html: string
  deps?: unknown[]
}

interface ShinyInputBindings {
  register(binding: object, name?: string): void
}

interface Shiny {
  addCustomMessageHandler(
    type: string,
    handler: (data: any) => void | Promise<void>
  ): void
  inputBindings: ShinyInputBindings
  setInputValue(
    name: string,
    value: unknown,
    opts?: { priority?: 'event' | 'deferred' | 'immediate' }
  ): void
  unbindAll(scope: Element, includeSelf?: boolean): void
  renderContentAsync(
    el: Element,
    content: ShinyRenderContent | string,
    where?: InsertPosition
  ): Promise<void>
}

interface Window {
  Shiny?: Shiny
}

// Events triggered by Shiny carry extra fields beyond jQuery's event object.
interface ShinyInputChangedEvent extends JQuery.TriggeredEvent {
  el: HTMLElement | null
  name: string
  value: unknown
  inputType: string
  priority?: string
}

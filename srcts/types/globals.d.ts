// Shiny's real types come from the rstudio/shiny repo (installed as
// @types/rstudio-shiny, same approach as bslib). Only declarations Shiny's
// types don't provide live here.

import type { ShinyClass } from 'rstudio-shiny/srcts/types/src'
import type { HtmlDep } from 'rstudio-shiny/srcts/types/src/shiny/render'

declare global {
  interface Window {
    Shiny?: ShinyClass
  }

  // The { html, deps } payload shape produced by the R side for
  // renderContentAsync().
  interface ShinyRenderContent {
    html: string
    deps?: HtmlDep[]
  }

  // Events triggered by Shiny carry extra fields beyond jQuery's event object.
  interface ShinyInputChangedEvent extends JQuery.TriggeredEvent {
    el: HTMLElement | null
    name: string
    value: unknown
    inputType: string
    priority?: string
  }
}

export {}

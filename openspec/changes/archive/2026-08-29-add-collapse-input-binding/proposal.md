## Why

`collapse_panel()` is the last yonder component with no client-side binding.
Its server functions — `open_collapse_panel()`, `close_collapse_panel()`,
`toggle_collapse_panel()` — call `session$sendInputMessage()`, but nothing on
the client is registered for those ids, so the messages are dropped and all
three functions are inert. There is also no `input$<id>` for a panel, so an
app cannot react to a panel being opened or closed.

## What Changes

- Add a `bsides.collapse` input binding (`srcts/src/components/collapse.ts`,
  registered from `srcts/src/index.ts`) that finds `.bsides-collapse`
  elements.
- The binding reports `"open"` / `"closed"` as `input$<id>` and updates on
  Bootstrap's `shown.bs.collapse` / `hidden.bs.collapse` events.
- The binding handles input messages with `method` of `"open"`, `"close"`, or
  `"toggle"`, making the three existing server functions work as documented.
- The binding syncs `aria-expanded` and the `.collapsed` class on every
  current trigger element for the panel. A trigger is a separate tag from the
  panel, so it may be rendered later; syncing from the binding keeps such
  triggers correct when the panel is driven from the server.
- Fix: a panel created with `state = "open"` currently renders a trigger
  claiming `aria-expanded="false"`. Syncing triggers at bind time corrects it.
- Limitation: a message that arrives while the panel is animating is ignored,
  so two server calls in one reactive flush apply only the first. Bootstrap
  drops the second; this change specifies rather than papers over it.
- The binding disposes its Bootstrap `Collapse` instance in `unsubscribe()`,
  so a panel removed by `renderUI()`/`removeUI()` does not leak.
- Add coverage: a `collapse` fixture in `srcts/tests/gen-html.R` plus a block
  in `srcts/tests/test-bindings.mjs`, and `tests/testthat/test-collapse.R`.

The R API in `R/collapse.R` is unchanged. No breaking changes.

## Capabilities

### New Capabilities

- `collapse-panel`: the observable behavior of a collapse panel — the value it
  reports to Shiny, the server-driven open/close/toggle messages it accepts,
  and the trigger state it keeps in sync.

### Modified Capabilities

None. `openspec/specs/` is currently empty; this change introduces the first
spec.

## Impact

- New: `srcts/src/components/collapse.ts`, `tests/testthat/test-collapse.R`.
- Modified: `srcts/src/index.ts`, `srcts/tests/gen-html.R`,
  `srcts/tests/test-bindings.mjs`.
- Rebuilt: the committed bundles under `inst/www/` (`npm run build`).
- Unchanged: `R/collapse.R` and its documentation.
- Related: the same `unsubscribe()` dispose gap exists in `modal.ts`, tracked
  separately as `yonder-ooq`. It is out of scope here.

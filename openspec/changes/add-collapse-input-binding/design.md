## Context

See proposal.md — Why.

Constraints that shape the approach:

- `R/collapse.R` already sends `list(method = ...)` through
  `session$sendInputMessage(id, msg)`. The message shape is fixed; the client
  has to match it.
- `collapse_panel()` renders `<div id class="bsides-collapse collapse">`, and
  `collapse_panel_button()` renders a separate `[data-bs-toggle="collapse"]`
  button with `data-bs-target="#<id>"`. The two are independent tags, so a
  trigger may appear anywhere on the page and may be rendered after the panel.
- Bootstrap's own collapse data-api already handles trigger clicks. Anything
  we add has to sit alongside it without toggling twice.
- Bootstrap's `Collapse` constructor caches its trigger list in a private
  `_triggerArray` at construction time, and `_addAriaAndCollapsedClass()` is
  private. Triggers added after the instance was built are invisible to it.
- Bindings in `srcts/src/components/` extend `NativeEventInputBinding`
  (`_utils.ts`), which scopes listeners to a per-element `AbortController` and
  detaches them in `unsubscribe()`.

## Goals / Non-Goals

**Goals:**

- One binding module that satisfies every requirement in
  `specs/collapse-panel/spec.md`.
- No reliance on Bootstrap private API for reading state.
- Coverage in the jsdom harness that exercises the real bundle against
  R-generated markup.

**Non-Goals:**

- Changing `R/collapse.R`, its arguments, or its documentation.
- A shinytest2 e2e app for collapse. The jsdom harness runs the real Bootstrap
  and the real bundle, which is enough for this component.
- Fixing the same dispose gap in `modal.ts` (`yonder-ooq`).
- Supporting an accordion `parent` config. `collapse_panel()` exposes no such
  argument.

## Decisions

### Read state from the `.show` class, not from Bootstrap

`getValue()` returns `el.classList.contains('show') ? 'open' : 'closed'`.

Bootstrap's own `_isShown()` is exactly this check, so the class is the source
of truth either way. Reading it directly means `getValue()` needs no
`Collapse` instance and no private-field cast.

Bootstrap removes `.show` at the start of a hide and adds it at the end of a
show, so `getValue()` reads `"closed"` for the whole of both transitions. That
is fine: Shiny calls `getValue()` on bind and from our `shown`/`hidden`
handlers, all resting states. Do not "improve" it by consulting `.collapsing`
— the resting-state reads are the contract, and Bootstrap's `show()`/`hide()`
guards already handle the transition window.

Alternative: mirror `modal.ts`, which subclasses `Modal` and casts to reach
`_isShown`. Rejected — the cast earns its keep there because `Modal` sets
`_isShown` before it adds the `.show` class, so the two disagree during the
show transition. `Collapse` has no such field to disagree with, so the cast
would be gratuitous.

### Obtain the Bootstrap instance with `{ toggle: false }`

Every call site uses `Collapse.getOrCreateInstance(el, { toggle: false })`.

`Collapse`'s default config is `toggle: true`, and the constructor calls
`this.toggle()` when it is set. Creating an instance with the defaults would
flip the panel as a side effect of the first server message. Bootstrap's own
data-api passes `toggle: false` for the same reason.

### Do not listen for trigger clicks

The binding subscribes only to `shown.bs.collapse` and `hidden.bs.collapse` on
the panel. Bootstrap's data-api handles the click and emits those events;
adding our own click handling would toggle twice.

Both events fire after the CSS transition completes, which is what the spec
requires — no value is reported mid-transition.

### Sync triggers ourselves, at bind time and on every state change

A private helper queries the document for `[data-bs-toggle="collapse"]`
elements, takes each one's `data-bs-target ?? href` as a selector, and keeps
those for which `panel.matches(selector)` is true — inside a `try/catch`,
because an `href` such as `https://…` is not a valid selector. That is the
same resolve-then-compare Bootstrap performs; its `SelectorEngine` is not
exported from the package entry, so we cannot call it. The helper then sets
`aria-expanded` and toggles `.collapsed` on each match. It runs from
`initialize()`, which Shiny calls once per bind before the first `getValue()`,
and from both event handlers.

Bootstrap does this only for the triggers its instance captured at
construction. Because `collapse_panel_button()` is a separate tag, a trigger
rendered by `renderUI()` after the panel would keep stale state forever. A
document query at state-change time always sees the current set.

This also corrects the initial state: `collapse_panel_button()` hardcodes
`aria-expanded="false"`, so a panel created with `state = "open"` currently
ships a trigger that lies about it. Syncing on bind fixes that without
touching `R/collapse.R`.

Alternative: re-create the `Collapse` instance on every state change so its
`_triggerArray` is rebuilt. Rejected — more work, and it still leaves the
bind-time mismatch.

### Dispose the instance in `unsubscribe()`

`unsubscribe()` calls `super.unsubscribe(el)` to abort the listener
controller, then `Collapse.getInstance(el)?.dispose()`.

`dispose()` removes Bootstrap's `bs.collapse` entry from its element data map.
Without it, a panel removed by `removeUI()` leaves a live instance pointing at
a detached element, and a later panel with the same id can pick up stale
state. `getInstance` rather than `getOrCreateInstance`, so tearing down a
never-messaged panel does not construct an instance just to destroy it.

### `receiveMessage` dispatches on `method`

`open` → `show()`, `close` → `hide()`, `toggle` → `toggle()`; anything
else is ignored. Bootstrap's `show()`/`hide()` already no-op when the panel
is already in that state (the idempotence scenarios) or is mid-transition
(the "Message received during a transition" scenario) — no extra guarding
needed.

The binding does not call `announce()`: Bootstrap's own events drive the
subscription, so an extra synthetic `change` would double-report.

## Risks / Trade-offs

- Document-wide trigger query on every state change → panels and triggers are
  few, and the query runs only on discrete open/close events, not per frame.
- Depending on the `.show` class as the state contract → it is Bootstrap's own
  public CSS class and how `_isShown()` is implemented; a change to it would
  break Bootstrap's own stylesheet first.
- Messages arriving mid-transition are dropped, not queued. The spec
  requires this ("Message received during a transition"); the design just
  inherits it from Bootstrap's `_isTransitioning` guard rather than adding a
  queue.
- `dispose()` nulls `_element`, but a transition already under way still has
  its `complete` callback pending (Bootstrap's `_queueCallback` has a timeout
  fallback, so it fires even after removal from the DOM). Unbinding a panel
  during its animation therefore logs a `TypeError` from inside a timer → the
  app is unaffected, the window is one animation, and `modal.ts` has the same
  hazard. Accepted; deferring `dispose()` until `shown`/`hidden` is not worth
  the bookkeeping.
- The jsdom harness has no CSS transitions, so `shown`/`hidden` fire
  synchronously there. The test block must not assume a transition delay it
  will not observe; the e2e-free coverage therefore proves dispatch and value
  reporting, not animation timing.

## Migration Plan

None. Additive change; the R API and rendered markup are unchanged. Rollback
is reverting the commit and rebuilding `inst/www/`.

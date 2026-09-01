# collapse-panel Specification

## Purpose

Defines the observable behavior of a collapse panel: the value it reports to
Shiny, the server-driven open, close, and toggle messages it accepts, and the
trigger state it keeps in sync on the panel's triggers.

## Requirements

### Requirement: Panel reports its state as a Shiny input

A collapse panel SHALL expose its state to the server as `input$<id>`, where
`<id>` is the panel's id. The value SHALL be the string `"open"` when the
panel is expanded and `"closed"` when it is collapsed.

#### Scenario: Initial value of a closed panel

- **WHEN** a panel created with `state = "closed"` is bound
- **THEN** its input value is `"closed"`

#### Scenario: Initial value of an open panel

- **WHEN** a panel created with `state = "open"` is bound
- **THEN** its input value is `"open"`

#### Scenario: Value updates when the panel finishes opening

- **WHEN** a closed panel finishes expanding, whether by user interaction or
  by a server message
- **THEN** its input value becomes `"open"`

#### Scenario: Value updates when the panel finishes closing

- **WHEN** an open panel finishes collapsing, whether by user interaction or
  by a server message
- **THEN** its input value becomes `"closed"`

#### Scenario: Value is not reported mid-transition

- **WHEN** a panel is in the middle of an open or close transition
- **THEN** no new input value is sent until the transition completes

### Requirement: Server can open, close, and toggle a panel

A collapse panel SHALL accept messages addressed to its id that carry a
`method` of `"open"`, `"close"`, or `"toggle"`, and SHALL change state
accordingly. These messages back `open_collapse_panel()`,
`close_collapse_panel()`, and `toggle_collapse_panel()`.

A message that arrives while the panel is mid-transition is ignored. In
particular, two messages sent in the same reactive flush — an open followed by
a close, or two toggles — apply only the first; the panel settles in the state
the first message requested.

#### Scenario: Opening a closed panel

- **WHEN** the panel is closed and receives a message with method `"open"`
- **THEN** the panel expands and its input value becomes `"open"`

#### Scenario: Opening an already open panel

- **WHEN** the panel is open and receives a message with method `"open"`
- **THEN** the panel remains open and no state change is reported

#### Scenario: Closing an open panel

- **WHEN** the panel is open and receives a message with method `"close"`
- **THEN** the panel collapses and its input value becomes `"closed"`

#### Scenario: Closing an already closed panel

- **WHEN** the panel is closed and receives a message with method `"close"`
- **THEN** the panel remains closed and no state change is reported

#### Scenario: Toggling a panel

- **WHEN** the panel receives a message with method `"toggle"`
- **THEN** the panel moves to the opposite state and reports the new value

#### Scenario: Message received during a transition

- **WHEN** the panel is in the middle of an open or close transition and
  receives a message with method `"open"`, `"close"`, or `"toggle"`
- **THEN** the message is ignored, the transition in progress completes, and
  the value reported is the state that transition was moving to

#### Scenario: Unrecognized method

- **WHEN** the panel receives a message whose `method` is absent or is not
  one of `"open"`, `"close"`, or `"toggle"`
- **THEN** the panel state is left unchanged and no error is raised

### Requirement: Triggers reflect the panel's state

A trigger element is any element on the page marked as a collapse toggle
whose target is the panel. Every trigger element for a panel SHALL reflect the
panel's current state through its `aria-expanded` attribute and its collapsed
styling, no matter what caused the state change.

#### Scenario: Trigger reflects the panel's state at bind time

- **WHEN** a panel is bound
- **THEN** each of its triggers reflects the panel's current state, including
  when the panel was created open

#### Scenario: Trigger reflects a server-driven open

- **WHEN** a closed panel is opened by a server message
- **THEN** each of its triggers reports `aria-expanded="true"` and is no
  longer styled as collapsed

#### Scenario: Trigger reflects a server-driven close

- **WHEN** an open panel is closed by a server message
- **THEN** each of its triggers reports `aria-expanded="false"` and is styled
  as collapsed

#### Scenario: Trigger added after the panel

- **WHEN** a trigger element for a panel is inserted into the page after the
  panel was bound, and the panel's state then changes
- **THEN** that trigger reflects the new state on the same terms as triggers
  present when the panel was bound

#### Scenario: Multiple triggers for one panel

- **WHEN** several trigger elements target the same panel and the panel's
  state changes
- **THEN** all of them reflect the new state

### Requirement: Removing a panel releases its resources

When a collapse panel is removed from the page or unbound, the panel SHALL
release the client-side resources it holds — event listeners and its
underlying collapse instance — so that repeatedly rendering and removing
panels does not accumulate them.

#### Scenario: Unbinding a panel

- **WHEN** a bound panel is unbound
- **THEN** its event listeners are detached and its collapse instance is
  disposed, leaving no state attached to the element

#### Scenario: Re-rendering a panel with the same id

- **WHEN** a panel is unbound, removed, and a new panel with the same id is
  rendered and bound
- **THEN** the new panel reports its own initial state and responds to
  messages, with no interference from the removed panel

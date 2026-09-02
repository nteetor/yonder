# function-naming

## Purpose

The naming contract for exported functions: constructors and readers are
noun-first so a component's pieces group under tab completion; server-side
actions are verb-first so server code reads as a sequence of verbs. Mirrors
bslib's rule from rstudio/bslib#706.

## ADDED Requirements

### Requirement: UI constructors are noun-first

An exported function that returns UI — a component, one of its parts, or a
control that triggers or dismisses it from the page — SHALL be named for
the component first, with the part or control as a suffix
(`modal_dialog()`, `modal_header()`, `modal_button()`,
`modal_close_button()`, `modal_close_icon()`, `collapse_panel_button()`).
A constructor SHALL NOT carry a verb prefix, and its suffix SHALL NOT be
a bare verb that reads as a server action: a control is
`<component>_button()`, `<component>_<role>_button()`, or — when it
renders an icon and no label — `<component>_<role>_icon()`; never
`<component>_close()` or `<component>_toggle()`.

#### Scenario: A trigger button is named as a control

- **WHEN** a component offers a button that opens or toggles it from the
  page
- **THEN** the constructor is `<component>_button()`, and no exported
  function named `<component>_toggle()`, `<component>_show()`, or
  `<component>_open()` returns UI

#### Scenario: A dismiss button is named as a control

- **WHEN** a component offers a button that closes or dismisses it from
  the page
- **THEN** the constructor is `<component>_close_button()` when it
  carries a label (`modal_close_button()`) and `<component>_close_icon()`
  when it is icon-only (`modal_close_icon()`, `alert_close_icon()`), and
  no exported function named `<component>_close()`,
  `<component>_dismiss()`, or a bare `<component>_button()` that
  dismisses returns UI

#### Scenario: Completing a component's name lists its pieces

- **WHEN** a user tab-completes `modal_`
- **THEN** the completions are the modal's constructors (`modal_dialog`,
  `modal_body`, `modal_header`, `modal_footer`, `modal_title`,
  `modal_button`, `modal_close_button`, `modal_close_icon`) and no server
  action

### Requirement: Server-side actions are verb-first

An exported function whose effect is a message to the client — showing,
hiding, opening, closing, toggling, starting, cancelling, resetting,
submitting, or updating a component — SHALL be named
`<verb>_<component>()`. The verb SHALL be chosen from a fixed vocabulary
by the kind of component and action:

- `show_` and `hide_` for content shown or hidden dynamically — modals,
  offcanvas, toasts, and any later overlay or revealed content.
- `open_` and `close_` for in-flow disclosures such as collapse panels
  (`open_collapse_panel()`, `close_collapse_panel()`, per the
  `collapse-panel` capability).
- `toggle_` only for binary state the component also reports to the
  server (`toggle_collapse_panel()`).
- `update_` for changing a component's label, choices, value or
  selection, or enabled state.
- `start_`, `cancel_`, and `reset_` for actions on a process the
  component owns.
- `submit_` for forms only (`submit_form()`); no other component submits.

#### Scenario: Modal actions

- **WHEN** server code shows or hides a modal
- **THEN** it calls `show_modal(modal, session)` and `hide_modal(session)`;
  `modal_show()` and `modal_hide()` are not exported

#### Scenario: File upload actions

- **WHEN** server code starts or cancels a file input's batch
- **THEN** it calls `start_file_upload(id, session)` and
  `cancel_file_upload(id, session)`; `file_upload_start()` and
  `file_upload_cancel()` are not exported

#### Scenario: New content shown dynamically

- **WHEN** a component whose content is shown or hidden on demand is
  added — an overlay, a drawer, a notification
- **THEN** its server actions are `show_<component>()` and
  `hide_<component>()`, not `open_`/`close_` or `toggle_`

#### Scenario: Form submission

- **WHEN** server code submits a form
- **THEN** it calls `submit_form(id, value, session)`, and `submit_` is
  used by no other component's actions

### Requirement: Updaters are named for the bare component

The `update_*()` function for an input SHALL be `update_<component>()`,
where `<component>` is the input's name without its `input_` prefix and
without an `_input` suffix (`input_menu()` → `update_menu()`,
`input_select()` → `update_select()`, `input_file()` → `update_file()`).

#### Scenario: Menu updater

- **WHEN** server code updates a menu input's label, selection, or enabled
  state
- **THEN** it calls `update_menu(id, ...)`; `update_menu_input()` is not
  exported

### Requirement: Readers are noun-first

An exported function that reads a component's state from the server
without changing it SHALL be named `<component>_<facet>()`
(`file_upload_status()`, `file_upload_progress()`,
`file_upload_staged()`, `file_upload_error()`), so readers complete
alongside the component and apart from its verbs.

#### Scenario: Upload readers keep their names

- **WHEN** the file upload actions are renamed verb-first
- **THEN** the four readers keep their `file_upload_` names and are
  documented together, with the two actions cross-referenced from the
  same help page

### Requirement: Renamed functions leave no alias behind

When an exported function is renamed or removed to satisfy this contract,
the old name SHALL be removed in the same release with no deprecation
shim, alias, or lifecycle warning, and the change SHALL be recorded in
NEWS as a breaking change.

#### Scenario: Old name is gone

- **WHEN** an app calls `modal_show()`, `modal_hide()`, `modal_toggle()`,
  `modal_close()`, `modal_dismiss()`, `alert_button()`,
  `file_upload_start()`, `file_upload_cancel()`, or `update_menu_input()`
- **THEN** R reports the function as not found; no deprecation message is
  emitted and no alias is exported

#### Scenario: NEWS records every rename

- **WHEN** the release's NEWS is read
- **THEN** each rename appears under breaking changes with its old and
  new name, the removal of `modal_close()` names its replacement, and no
  other NEWS entry still refers to an old name

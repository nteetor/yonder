# Design: rename server verbs

## Context

See proposal.md for motivation. The facts that shape the approach:

- The package is a reboot with no lifecycle machinery; removals are
  clean. There is nothing to migrate, only names to change and every
  reference to find.
- None of the nine functions was exported in the last release (v0.2.0
  exported `modal()` and `collapsePane()`), so the change breaks only
  apps built against the development version. NEWS already lists
  development-version renames under "Breaking changes"; these join
  them.
- The collapse panel is the existing instance of the rule on `main`:
  `open_collapse_panel()`, `close_collapse_panel()`, and
  `toggle_collapse_panel()` (PR #233). Its NEWS bullet under "New
  features" already states that server-side functions are verb-first,
  following bslib, and `openspec/specs/collapse-panel/spec.md` names the
  three functions.
- Roxygen layout differs per function. `modal_show()` heads its own Rd
  with `modal_hide()` joined by `@rdname`. `modal_toggle()` is a
  `@describeIn modal_dialog`. `modal_close()` and `modal_dismiss()` are
  `@describeIn modal_body`, where `modal_header()` and `modal_footer()`
  take them as their `close` defaults and the shared `@param close` and
  `@param text` describe them. `update_menu_input()` is `@rdname
  input_menu`. `file_upload_start()` heads the "File upload actions and
  state" block and the other five functions join it by `@rdname
  file_upload_start` — so the Rd file is named for a verb that is going
  away.
- `modal_close()` renders Bootstrap's icon-only `.btn-close` with
  `aria-label = "Close"`; `modal_dismiss(..., text = "Close")` renders a
  `.btn.btn-primary` carrying `text` as both label and `aria-label`.
  Both set `data-bs-dismiss="modal"`; Bootstrap treats them alike.
  `alert_button()` is the same `.btn-close` with
  `data-bs-dismiss="alert"`, the default of `alert()`'s `dismiss_button`.
- The R names cross the boundary only as comments and snake_case
  message keys: `srcts/src/components/webcomponents/file.ts` names the
  verbs in two comments, and the committed bundles in
  `inst/www/yonder/js/` carry those comments. The custom message names
  `bsides:modalShow`/`bsides:modalClose` and the keys
  `upload_start`/`upload_cancel` are read by `srcts/src/components/
  modal.ts` and `file.ts` and are unrelated to the R names.
- Beads yonder-uis, yonder-2pe, yonder-eke, and yonder-i3y already
  describe the four units of work; yonder-was records the `show_`/`hide_`
  decision.

## Goals / Non-Goals

**Goals:**

- Every exported name satisfies the `function-naming` spec.
- No reference to an old name survives anywhere in the repository:
  code, roxygen, Rd, NEWS, examples, tests, TypeScript comments, or
  committed bundles.
- A modal built from `modal_header()` and `modal_footer()` defaults
  renders the same markup as today.
- The help pages read as the spec groups them: readers together,
  verbs cross-referenced.

**Non-Goals:**

- Touching `R/collapse.R`; it already satisfies the spec.
- Changing any message name or key on the wire.
- Changing any renamed function's behaviour beyond the `...` handling
  the proposal states.

## Decisions

### Rename in place, no shims

Each function is renamed where it is defined; the old name is not
re-exported, aliased, or wrapped. `devtools::document()` regenerates
`NAMESPACE` and `man/`; roxygen2 removes the Rd files it generated that
are no longer produced, so `modal_show.Rd` and `file_upload_start.Rd`
disappear with that run and no manual deletion is needed.

Alternative rejected: keep old names as thin wrappers for one release.
The package's stated policy is no deprecation cycle, and the wrappers
would themselves violate the naming spec they exist to introduce.

### Two close constructors, named for what they return

`modal_close_icon(...)` renders Bootstrap's `.btn-close` with
`data-bs-dismiss = "modal"` and `aria-label = "Close"`; `...` are attributes
of the button element. `modal_close_button(..., label = "Close")` renders
the `.btn.btn-primary` carrying `label`, as `modal_dismiss()` did, and
passes `...` as attributes of the button — `modal_dismiss()` took `...` and
never used it. They are two functions rather than one with a look switch
because they return two different things — an icon control and a labelled
button — and constructors are named for what they return. `modal_header()`
keeps `close = modal_close_icon()` and `modal_footer()` keeps `close =
modal_close_button()`; the default modal's markup is unchanged.

Alternatives rejected:

- *One constructor with `appearance = c("icon", "text")`*: `label` would
  be dead for the icon form, and the header default would have to spell
  out `appearance = "icon"` for the control the header always wants.
- *`modal_close_button(label = NULL)` for the icon form*: a sentinel
  standing in for a second constructor.
- *A `close_button = c("icon", "none")` argument on `modal_header()`
  instead of a `close` tag*: the header would render one control it
  cannot be handed, while `modal_footer()` takes a tag; keeping `close`
  on both makes the two symmetric and lets a caller pass any control.

On the suffix: `_icon` was weighed against reading as a static glyph
rather than a control. It stays because the alternative names
(`modal_close_icon_button()`, an appearance switch) cost more than the
ambiguity, and the Rd states that it is a button.

### `alert_close_icon()`

`alert_button()` is renamed in place to `alert_close_icon(...)`, with
`...` as attributes of the button element; `alert()`'s `dismiss_button`
default follows, and its `@param dismiss_button` text names the new
function. The rename is its own bead (yonder-9dt.2) because it is a
separate decision under the same contract, not part of the modal one.

### Rd ownership follows the noun

- `show_modal()` heads its Rd; `hide_modal()` joins by `@rdname
  show_modal`. The page title stays "Modal server functions".
- `modal_button()` stays a `@describeIn modal_dialog`, as
  `modal_toggle()` was; its one-line description changes from "Open a
  modal" to name it as the trigger button.
- `modal_close_icon()` and `modal_close_button()` are `@describeIn
  modal_body`; the page's `@param close` names each as its default,
  `@param ...` already says named values are attributes, and `@param
  label` is `modal_close_button()`'s text.
- `update_menu()` stays `@rdname input_menu`.
- The file upload block moves so the readers own the page: the roxygen
  header moves to `file_upload_status()` with `@name file_upload`, the
  other three readers and the two verbs join by `@rdname file_upload`.
  The page is then `?file_upload`, its prose still lists the actions
  first (as now) but under their new names, and `?start_file_upload`
  resolves to it. The header's `@seealso` gains nothing; the verbs are
  on the same page.

Alternative rejected for the upload page: give the verbs their own Rd
(`?start_file_upload`) and cross-link the readers. The prose is one
explanation of a single state machine — the actions move it, the
readers observe it — and splitting it would duplicate that
explanation. yonder-2pe asked for exactly the readers-own,
verbs-join arrangement.

### One NEWS bullet, and the existing mentions follow

One bullet under "Breaking changes" lists the renames old → new
(`modal_close()`, `modal_dismiss()`, and `alert_button()` included), and
refers to the rule the collapse bullet under "New features" already states
rather than restating it. The three existing mentions of old names in NEWS
(`update_menu_input()` in the `text` → `label` entry;
`file_upload_start()`/`file_upload_cancel()` in the `input_file()` entries)
are rewritten to the new names, since NEWS describes the package as
released, not as it was mid-development.

### Comments cross the boundary; the bundle follows the source

The two comments in `file.ts` are rewritten to the new names. Nothing
executable changes in `srcts/`, but the committed bundles and source
maps under `inst/www/yonder/js/` embed those comments, so `npm run
build` runs and the rebuilt bundles are committed with the rename.
Leaving the bundle stale would leave `grep file_upload_start` finding
a hit and would make the next unrelated build a noisy diff.

### Beads: reuse the four child issues

The apply step creates the change's epic and re-parents yonder-uis,
yonder-2pe, yonder-eke, and yonder-i3y under it rather than creating
duplicates, adding an acceptance line to each: the repository-wide
grep for the old name returns nothing, `devtools::document()` is
clean, and the scoped test file passes. yonder-i3y's open question
(`modal_close()`/`modal_dismiss()`) is answered by the proposal — both
go, `modal_close_button()` replaces them — and its title and
description are updated when it is claimed. yonder-was is linked to the
epic as the decision behind `show_modal()`/`hide_modal()`. No
dependencies among the four; they can be worked in any order and `bd
ready` lists all of them.

## Risks / Trade-offs

- [A reference to an old name survives in prose or a comment] → the
  acceptance for every issue is a repository-wide grep for the old
  name (excluding `.git`, `renv`, and `node_modules`), not just a green
  test run.
- [`R CMD check` flags a dangling `\link` to a retired topic] →
  `devtools::document()` then `devtools::check()` after the last rename,
  before the change is archived.
- [`?file_upload_start` no longer resolves] → intended; `?start_file_upload`
  does. There is no released version to hold the old topic name.

## Migration Plan

None. The change ships in the next release; NEWS is the migration note.

# Rename server verbs

Bead: yonder-9vy (children yonder-uis, yonder-2pe, yonder-eke, yonder-i3y,
yonder-9dt.2; related decision yonder-was)

## Why

yonder-9vy adopted bslib's naming rule (rstudio/bslib#706): UI constructors
are noun-first so tab completion groups a component's pieces, and
server-side actions are verb-first because server code reads verb-first.
The collapse panel already follows it on `main` (`open_collapse_panel()`
and siblings, PR #233). Two server-side pairs still carry the old
noun-first shape, one updater carries a stray `_input` suffix, three UI
constructors are named like actions, and one dismiss control is named
as if it were a trigger. Every one is a public export, so
each day they stay is another app written against names that will change.

## What Changes

- **BREAKING** `modal_show()` and `modal_hide()` become `show_modal()` and
  `hide_modal()`, matching shiny's `showModal()` and bslib's
  `show_offcanvas()`. Signatures are unchanged; `hide_modal()` still takes
  no id. `show_`/`hide_` is the vocabulary for any content shown or hidden
  dynamically (yonder-was), so this is the pattern later overlays follow.
- **BREAKING** `file_upload_start()` and `file_upload_cancel()` become
  `start_file_upload()` and `cancel_file_upload()`. The four readers
  (`file_upload_status()`, `file_upload_progress()`,
  `file_upload_staged()`, `file_upload_error()`) read input state rather
  than act, so they keep their noun-first names. The readers currently
  share an Rd owned by `file_upload_start`; the readers take over the
  `file_upload` Rd and the two verbs join it by `@rdname`.
- **BREAKING** `update_menu_input()` becomes `update_menu()`. It is the
  only updater that repeats an `_input` suffix; every other is named for
  the bare component (`update_select()`, `update_file()`).
- **BREAKING** `modal_toggle()` becomes `modal_button()`. It constructs a
  trigger `<button data-bs-toggle="modal">`, not an action, and the name
  reads as a server verb beside `toggle_collapse_panel()`. `modal_button()`
  matches `collapse_panel_button()`.
- **BREAKING** )` becomes `modal_close_icon(...)` and `modal_dismiss(..., text
  = )` becomes `modal_close_button(..., label = )`. Both were the modal's
  dismiss controls under bare-verb names; they are two constructors because
  they return two things — Bootstrap's icon-only `.btn-close`, and a labelled
  `.btn`. `modal_header()` and `modal_footer()` keep their `close` tag
  argument, defaulting to `modal_close_icon()` and `modal_close_button()`. On
  both, `...` are attributes of the button element; `modal_dismiss()` accepted
  `...` and silently dropped it. `label` matches the package's argument for a
  control's visible text. A modal built from defaults looks as it does today.
- **BREAKING** ()` becomes `alert_close_icon(...)`, with `...` as attributes
  of the button element. It is the alert's icon-only `.btn-close`; the bare
  `_button()` suffix says nothing about closing and, beside `modal_button()`,
  reads as a trigger. Distinct from the modal decision, same contract.
- No deprecation shims or aliases: the package is a reboot and carries no
  lifecycle machinery. The old names are removed outright and NEWS records
  every rename under breaking changes.
- The custom message names (`bsides:modalShow`, `bsides:modalClose`) and
  the input message keys (`upload_start`, `upload_cancel`) are wire
  protocol, not API, and do not change. Comments that tie them to the R
  function names are updated.
- The collapse panel functions are already verb-first and are not
  touched; the `function-naming` spec cites them as the existing instance
  of the `open_`/`close_`/`toggle_` vocabulary.

## Capabilities

### New Capabilities

- `function-naming`: the noun-first / verb-first contract for exported
  functions — which functions are constructors, actions, updaters, and
  readers, the verb vocabulary each kind of action uses, and the concrete
  names this change settles.

### Modified Capabilities

None. `file-upload` and `collapse-panel` describe behaviour under names
that already satisfy the contract or that they do not mention, so no
requirement in either changes.

## Impact

- `R/modal.R` — `modal_show()`, `modal_hide()`, `modal_toggle()`,
  `modal_close()`, `modal_dismiss()` renamed; the `modal_show` Rd becomes
  `show_modal`; `modal_button()` stays under the `modal_dialog` Rd and
  `modal_close_icon()`/`modal_close_button()` under `modal_body`, whose
  `close` and `label` parameter docs are rewritten.
- `R/alert.R` — `alert_button()` renamed under the `alert` Rd;
  `alert()`'s `dismiss_button` default follows.
- `R/input-file.R` — `file_upload_start()`, `file_upload_cancel()`
  renamed; the shared roxygen block moves to `file_upload_status()`
  under `@name file_upload`, with the verbs joining by `@rdname`; the
  prose naming the verbs is updated.
- `R/input-menu.R` — `update_menu_input()` renamed under the
  `input_menu` Rd.
- `NAMESPACE`, `man/` — regenerated by `devtools::document()`.
- `NEWS.md` — one breaking-changes entry listing the renames and the
  removal; existing mentions of `update_menu_input()` (the `text` →
  `label` entry) and of `file_upload_start()`/`file_upload_cancel()` (the
  `input_file()` entries) are updated to the new names.
- `inst/demos.R`, `inst/examples-shiny/kitchen-sink/app.R`,
  `inst/examples-shiny/input-file/app.R` — call sites and prose.
- `tests/testthat/test-file.R`, `tests/testthat/test-file-e2e.R`,
  `tests/testthat/apps/file/app.R`, `tests/testthat/apps/bindings/app.R`
  — call sites, test names, and comments.
- `srcts/src/components/webcomponents/file.ts` — two comments name the
  R verbs; the bundles in `inst/www/yonder/js/` carry them and are
  rebuilt so the committed bundle matches the source.
- Open beads yonder-uis, yonder-2pe, yonder-eke, and yonder-i3y are the
  work breakdown; they are re-parented under this change's epic rather
  than duplicated. yonder-i3y's scope grows to cover `modal_close()` and
  `modal_dismiss()`; yonder-9dt.2 carries the alert rename.

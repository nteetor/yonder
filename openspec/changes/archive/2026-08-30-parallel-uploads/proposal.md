# Parallel uploads in Uploader

Bead: yonder-1ic

## Why

The `Uploader` runs Shiny's upload protocol one file at a time: each file
is a full POST round trip, serialized behind the previous one. That was
defensible when a batch was one picker gesture, but staged mode exists to
build large sets — twenty staged files upload twenty round trips deep.
Dropzone and Uppy both default to concurrent uploads. Small-file batches
are latency-bound, not bandwidth-bound, so concurrency is nearly a free
speedup for the common case.

## What Changes

- `Uploader` uploads a batch's files concurrently, up to a fixed
  concurrency limit, instead of strictly sequentially. Both auto and
  manual (staged) modes get this — they share the module.
- The wire protocol changes from one Shiny upload job per batch to one
  job per file, because Shiny's server assigns each POST to the next
  declared file in arrival order — concurrent POSTs into a single job
  would scramble file/content attribution. Each file's job is finished
  (`uploadEnd`) into a per-slot companion input, and the batch's value —
  still a single `input$<id>` data frame, set once per batch — is
  assembled server-side by a new registered input handler when the
  client reports the completed batch.
- Progress reporting keeps its shape (`{file, loaded, batch}` events plus
  the aggregate batch fraction) but events from different files now
  interleave; the batch fraction stays monotone.
- Failure and cancel semantics are unchanged at the contract level: any
  file's failure fails the batch (in-flight POSTs are aborted, no value
  is delivered), and cancel aborts everything with no value delivered.

No new public R API and no new attributes on `<bsides-file>`; the
concurrency limit is an internal constant.

## Capabilities

### New Capabilities

- `file-upload`: the file input's upload transport contract — how a batch
  moves from the browser to `input$<id>`: concurrency, value assembly,
  progress aggregation, failure/cancel atomicity, and interaction with
  `input_form()` submission. (First spec in this project; no existing
  capability covers it.)

### Modified Capabilities

None — `openspec/specs/` is empty; this change introduces the capability.

## Impact

- `srcts/src/components/upload.ts` — the whole run loop: per-file
  init/POST/end pipeline with a concurrency pool, aggregate progress,
  first-error abort.
- `srcts/src/components/webcomponents/file.ts` — final value delivery
  (one `Shiny.setInputValue` per batch) and any assumptions about
  one-file-at-a-time progress; per-item rendering is already keyed by
  `File` and survives interleaving.
- `R/input-file.R`, `R/on-load.R` — new input handler that assembles the
  batch data frame from the per-slot companion inputs; handler
  registration.
- Tests: DOM harness for `Uploader` concurrency/ordering/failure paths,
  R tests for the assembly handler, e2e for both modes.
- Server compatibility: uses only long-stable Shiny surfaces
  (`uploadInit`/`uploadEnd`, `registerInputHandler`); no Shiny version
  bump required.

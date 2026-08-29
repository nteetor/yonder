# Design: parallel uploads

## Context

See proposal.md for motivation. The facts that shape the design, all
verified against the installed Shiny sources:

- Shiny's upload protocol per job: `uploadInit([fileInfos])` over the
  WebSocket returns `{jobId, uploadUrl}`; one raw POST per file to
  `uploadUrl`; `uploadEnd(jobId, inputId)` finishes the job — the server
  calls `FileUploadOperation$finish()` and sets `input$<inputId>` to the
  job's data frame directly.
- **Ordering constraint**: `FileUploadOperation$fileBegin()` pops
  `.pendingFileInfos[[1]]` per POST — declared metadata is bound to
  POSTs by *arrival order*, and a single `.currentFileData` handle is
  open at a time. Concurrent POSTs into one job scramble name↔content
  attribution. Parallelism therefore cannot happen inside one job.
- httpuv buffers each request body off the R thread, so concurrent POSTs
  genuinely overlap on the wire; only R-level handling serializes. The
  win is real for latency-bound batches of small files.
- `Uploader` (srcts/src/components/upload.ts) is the only transport
  path; auto and manual modes share it via `#start()` in
  `webcomponents/file.ts`.
- yonder's form binding (inputForm.ts) holds back child input sends that
  carry an element; `Shiny.setInputValue()` pushes carry no element and
  pass the freeze — the existing `__bsides_*` companions rely on this.
- Shiny's client dedupes `setInputValue` sends whose value is identical
  to the last sent for that name.

## Goals / Non-Goals

**Goals:**

- Concurrency inside `Uploader` with no change to the callbacks' shape
  and no change to `file.ts`'s state machine beyond value delivery.
- Only long-stable, public Shiny surfaces: `uploadInit`, POST,
  `uploadEnd`, `registerInputHandler`. No reach into Shiny private
  internals (`.__enclos_env__`), no Shiny version requirement.

**Non-Goals:**

- Per-file retry of a failed batch (failure stays batch-atomic).
- A public concurrency knob (R argument or attribute).
- Chunked/resumable uploads; any change to staging, validation, or the
  companion-input contract.

## Decisions

### One Shiny upload job per file

`uploadInit` is called once per file (a job of one file), so each POST
is unambiguous — the job's single declared file is the only thing its
POST can be attributed to. Concurrent POSTs then target distinct jobs.

Alternatives rejected:

- *Concurrent POSTs, single job*: broken by the arrival-order constraint
  above.
- *K "lane" jobs, files sequential within a lane*: fewer jobs but
  head-of-line blocking inside lanes, an extra packing decision, and the
  same value-assembly problem — strictly more design for less.

### Pipeline shape

1. **Init phase**: fire all N `uploadInit` requests concurrently and
   await all of them before any POST. Preserves today's "validate every
   size before any byte moves" behavior (`shiny.maxRequestSize` is
   enforced in `uploadInit`); any init failure fails the batch with
   nothing posted. WebSocket requests are cheap; N inits are fine.
2. **Transfer phase**: a pool with a fixed concurrency limit (constant
   `UPLOAD_CONCURRENCY = 4`; Dropzone defaults to 2, Uppy to 5) runs
   each file's POST; as each file's POST succeeds, its
   `uploadEnd(jobId_i, slotId_i)` runs as part of the same per-file
   chain (no barrier — a finished small file's job closes while a large
   one still transfers).
3. **Deliver phase**: after every per-file chain settles,
   the component sends one
   `Shiny.setInputValue('<id>:bsides.file.batch', payload)` where
   `payload = {seq, slots: [slotId_1..N]}`. A registered input handler
   assembles the final value (below), so `input$<id>` is set exactly
   once per batch, in declared order.

### Value assembly via slot inputs and a batch handler

`uploadEnd(jobId_i, slotId_i)` points each job at a per-slot companion
input, `slotId_i = '<id>__bsides_slot_<i>'` with `i` the file's declared
index. Shiny sets each slot input to a one-row data frame (name, size,
type, datapath) exactly as it sets a whole-batch value today.

The new input handler (`bsides.file.batch`, registered alongside the
existing `bsides.file.staged`/`bsides.file.error` handlers in
`R/on-load.R`) receives the batch payload, `isolate()`-reads each slot
input from `session$input` in slot order, rbinds the rows, and returns
the combined data frame — which lands on `input$<id>` because the
client sends the payload under the name `<id>:bsides.file.batch`.

Why this works without races: WebSocket messages are processed in order,
and the client sends the batch payload only after every `uploadEnd`
request has resolved, so by the time the handler runs every slot input
is set. Slot ids are indexed by position, not by a per-batch token, so a
session accumulates at most `max batch size` slot inputs per file input
— batches never overlap (one flight per input), so reuse is safe.

The `seq` field is a per-input monotone counter. It makes consecutive
identical batches distinct payloads so Shiny's client-side send dedupe
cannot swallow the second one (spec: "Consecutive identical batches both
deliver").

Alternatives rejected:

- *Finish jobs from R via `session`'s private `fileUploadContext`*
  (handler receives ordered jobIds, calls `getUploadOperation()$finish()`
  itself): cleanest runtime surface, no slot inputs — but requires
  `.__enclos_env__` access to Shiny internals; fragile across Shiny
  releases and a CRAN smell. Slot inputs match the existing
  `__bsides_*` companion idiom anyway.
- *`uploadEnd(jobId_i, '<id>')` per job*: sets the main input N times
  with one-row values — breaks the batch contract outright.

### Failure, cancel, progress

- First settled rejection anywhere (init, POST, uploadEnd) fails the
  batch: abort all in-flight XHRs, drop the queue, never send the batch
  payload. Existing `#fail`/`#finished` semantics already make this
  idempotent under multiple concurrent rejections; the pool adds an
  internal aborted flag it checks before starting each queued file.
- `cancel()` keeps its contract but must now abort a *set* of XHRs:
  `#xhr` becomes a set of in-flight requests. Un-ended jobs are orphaned
  server-side exactly as today's cancelled job is; the session cleans
  them up.
- Progress: `#doneBytes` is replaced by per-file loaded counters;
  the batch fraction is `(Σ per-file loaded, completed files at full
  size) / totalBytes`, clamped monotone. Per-file `onProgress` events
  keep `{file, loaded, batch}`; `onFileDone` fires per file as its chain
  completes. `file.ts` keys item state by `File` object, so interleaved
  events already land on the right rows.
- The comment block atop upload.ts describing the three-leg protocol and
  the `UploadProgress` doc ("files upload one at a time") must be
  rewritten to describe the per-file job pipeline.

### Value delivery moves client-side: consequences

- **Form freeze**: the batch payload is a `setInputValue` push with no
  element, so `input_form()`'s freeze passes it through — same
  observable behavior as today's server-side set. The form's submit
  blocker (`#openBatch`/`#settleBatch` in file.ts) must settle only
  after the payload send, preserving "value before form value" ordering
  (both ride the same in-order channel).
- **Bookmarking**: today `@uploadEnd` sets `serializerFileInput` on the
  main input so bookmarks redact it. With the handler route the restored
  value would be a stale batch payload; the handler must return `NULL`
  (or an empty frame) when a slot input is missing rather than error.
  Bookmark support for file values is already nominal in Shiny (values
  are redacted, not restored), so parity is "restores to no value,
  without error".

## Risks / Trade-offs

- [Slot inputs are visible in `names(input)`] → they follow the existing
  `__bsides_*` companion naming, are documented nowhere, and are bounded
  by max batch size; accepted.
- [Handler reads other inputs via `isolate()` — unconventional] → the
  ordering argument above makes it deterministic; covered by an R test
  driving a real session (shinytest2/testServer-level) rather than
  unit-mocking.
- [`uploadEnd`'s direct `.input$set` on slot inputs skips freeze
  machinery] → nothing observes slot inputs, so no observable change.
- [Server processing still serializes in R] → expected; the win is
  wire-level overlap. Not a regression for any batch shape: bandwidth-
  bound uploads perform as before.
- [More WebSocket chatter: N inits + N ends vs 2 messages] → messages
  are tiny relative to file bytes; negligible against the round trips
  saved.

## Open Questions

None.

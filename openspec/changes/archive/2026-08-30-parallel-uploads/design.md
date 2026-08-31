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
   `payload = {seq, n}` where `n` is the file count. A registered input
   handler assembles the final value (below), so `input$<id>` is set
   exactly once per batch, in declared order.

### Value assembly via slot inputs and a batch handler

`uploadEnd(jobId_i, slotId_i)` points each job at a per-slot companion
input, `slotId_i = '<id>__bsides_slot_<i>'` with `i` the file's declared
index. Shiny sets each slot input to a one-row data frame (name, size,
type, datapath) exactly as it sets a whole-batch value today.

The new input handler (`bsides.file.batch`, registered alongside the
existing `bsides.file.staged`/`bsides.file.error` handlers in
`R/on-load.R`) receives the batch payload, rebuilds `slotId_1..N` from
the handler's own `name` argument and the payload's count,
`isolate()`-reads each slot input from `session$input` in position
order, rbinds the rows, and returns the combined data frame — which
lands on `input$<id>` because the client sends the payload under the
name `<id>:bsides.file.batch`.

The payload carries a count rather than the slot names so that no
client-supplied string is ever dereferenced. Sending the names would let
a payload name any input in the session and have its value rbound into
`input$<id>`, and would error inside input dispatch — where an error
takes the session down — on an atomic payload or a non-string entry. The
count is validated as a whole number ≥ 1 and the payload is checked to
be an object at all; anything else yields NULL. Slot membership and
order become the server's to decide, and only one of the two languages
still spells the slot-name format out of choice.

Why this works without races: WebSocket messages are processed in order,
and the client sends the batch payload only after every `uploadEnd`
request has resolved, so by the time the handler runs every slot input
is set. Slot ids are indexed by position, not by a per-batch token, so a
session accumulates at most `max batch size` slot inputs per file input
— batches never overlap (one flight per input), so reuse is safe.

The `seq` field is a per-input monotone counter. It makes consecutive
identical batches distinct payloads so Shiny's client-side send dedupe
cannot swallow the second one (spec: "Consecutive identical batches both
deliver"). Sending the payload with `{priority: 'event'}` instead would
defeat the dedupe with no counter and no wire field, and is what
inputForm.ts does; it is not adopted here because `seq` is already in
place and verified across the awkward case (a `renderUI` re-render, where
`bindAll`'s initial null send overwrites the dedupe cache slot for the
bare name), and swapping the mechanism would rewrite a contract spanning
both languages, and the tests pinning it, for no observable difference.

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
- Progress: `#doneBytes` is replaced by per-file loaded counters, each
  held at its own high-water mark as it is written; the batch fraction is
  `(Σ per-file loaded, completed files at full size) / totalBytes`, and
  is monotone because a sum of counters that never fall cannot fall.
  Clamping at the counters rather than at the fraction keeps the reader
  free of side effects and gives each row's bar the same guarantee as the
  batch's. Per-file `onProgress` events
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

### Datapath basenames under one job per file

Shiny's `FileUploadOperation` names each file by its index within its
upload job (`file.path(dir, paste0(length(files), ext))`). One job per
file therefore writes every file as `0.<ext>`, where the single-job flow
produced `0.csv`, `1.csv`, `2.csv`. Full datapaths stay unique — each job
gets a private directory — but app code keyed on `basename(datapath)`,
the common `file.copy(datapath, file.path(dest, basename(datapath)))`
pattern, silently collapses a same-extension batch onto one name.

The batch handler renames instead of documenting the difference: a silent
collapse is too sharp an edge to leave to roxygen, and by the time the
handler runs it already knows each file's batch position. It rewrites
each row's basename to its position (`0.csv`, `1.csv`, ...), restoring
the single-job naming. Because every job owns a private directory the
targets cannot collide across files, so no cross-file coordination is
needed. A file that will not move — already renamed, or gone — keeps its
datapath, which makes the rename idempotent and keeps a value from
pointing at nothing.

### Which rows a failure marks

Sequential uploads had exactly one file in flight, so the component could
mark that row `error` and return every other row to `pending`. With a
pool, a failure aborts its siblings, and the old rule ("the row that was
uploading") would redden up to `UPLOAD_CONCURRENCY` rows for one bad
file.

`onError` therefore gains an optional second argument, the `File` whose
transfer rejected: `onError(message, file?)`. Rejections are tagged with
their file as they propagate (init, POST, and `uploadEnd` alike), so the
component marks the file that actually failed and returns its aborted
siblings to `pending`, ready for the retry — the pre-change user-facing
contract, preserved under concurrency. A failure belonging to the batch
rather than to one file (no connection, say) carries no file and marks
no row.

This is the one departure from "no change to the callbacks' shape" above.
It is additive: existing callers that ignore the second argument keep
working.

One case stays imperfect: a total outage rejects every in-flight transfer
at once, and the first rejection to arrive marks its file, so one
arbitrary row wears a mark that belongs to the batch. Recognising it
would mean waiting to see whether siblings fail too, and the failure path
cannot wait — a report held for its siblings is a report held behind a
sibling that never settles, which is the hang the batch must not have
(the reason `#transferAll`'s workers report from their own catch rather
than through the promise that joins them). An arbitrary mark is the
cheaper wrong, and manual mode's retry clears it.

## Risks / Trade-offs

- [The handler renames files on disk during input dispatch] → the
  per-slot inputs keep the pre-rename datapath, but nothing observes
  them; the rename is skipped rather than retried when the source is
  missing, so the value never points at nothing.
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

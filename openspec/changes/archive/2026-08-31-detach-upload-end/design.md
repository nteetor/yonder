# Design: detach uploadEnd from the pool slot

## Context

See proposal.md for motivation. The facts that shape the approach:

- The per-file chain in `Uploader.#transfer` is `POST → uploadEnd →
  onFileDone`, awaited end to end by the worker that owns the slot. The
  worker takes its next index only when the chain returns, so the slot
  is held across the job close.
- Measured on an unthrottled link with two 40 MB files among small ones
  (yonder-c7j): job closes queued behind the big bodies took 51, 101 and
  105 ms; after the big files landed, 6 and 7 ms. The 40 MB POSTs
  themselves took ~160 ms, so a slot spent most of a small file's life
  waiting on the close.
- R's `bsides.file.batch` handler reads every slot input under
  `isolate()` and relies on one ordering fact: the batch payload is sent
  only after every `uploadEnd` has resolved, and the socket delivers in
  order (R/input-file.R, comment above
  `file_batch_input_register_handler`).
- Shiny's client never rejects a pending `makeRequest` on a dropped
  socket, so anything that awaits an `uploadEnd` may wait forever. This
  is why `#transferAll`'s workers report failures from their own catch
  rather than through the promise that joins them, and why `run()` is
  fired as `void` from file.ts.
- `onFileDone` marks a row `done`; in auto mode a failure leaves done
  rows alone and marks the rest `error`.

## Goals / Non-Goals

**Goals:**

- A worker's slot frees the moment its file's POST resolves.
- Every behavior the `file-upload` spec already pins — delivery once and
  in order, failure atomicity, cancel, progress monotonicity, form
  ordering — holds unchanged, with the R-side ordering fact intact.
- Harness coverage that fails against the current code and passes
  against the fix, independent of timing.
- The same guarantee pinned end to end, in a real browser against a real
  Shiny session, as an ordering assertion rather than a timing one.

**Non-Goals:**

- Changing when a row reads `done`, the callbacks' shape, or the batch
  payload.
- Any server-side change to make job closes faster; R's single thread is
  the constraint, not a defect.
- Retrying or tolerating a failed job close.

## Decisions

### Split the chain at the POST; collect the closes for one join

`#transfer` returns once the POST resolves (or the batch has stopped).
The job close moves into its own chain, started from `#transfer` without
being awaited and recorded in a per-batch list of pending closes. That
chain is `uploadEnd → #isStopped() → onFileDone`, with a catch that
reports through `#fail(message, file)` and never rejects, so the list is
safe to join with `Promise.all`. The stop check between the close and
`onFileDone` is load-bearing: closes outliving the batch become the
normal case, and a close resolving after a cancel or failure would
otherwise flip a row the component has just returned to `pending`
(manual) or marked `error` (auto) into `done`.

`run()` awaits `#transferAll` (every POST landed or the batch stopped),
returns on `#isStopped()` — a stopped batch never awaits the join, which
a hung close could hold open — then awaits the join (every job closed),
checks `#isStopped()` again, reports the final checkpoint and finishes.
The payload therefore still leaves after the last `uploadEnd` resolves —
the ordering fact the R handler relies on — and the R comment stating it
stays true.

Alternatives rejected:

- *Free the slot by counting closes into the pool instead of joining
  them*: a separate accounting of "closes outstanding" that the deliver
  phase polls. Strictly more state for the same join.
- *Send the payload as soon as every POST lands and have R wait for the
  slots*: R cannot wait inside input dispatch, and the handler's "a
  missing slot is a bookmark restore, not a race" contract would become
  a race. Rejected.
- *Fire `onFileDone` when the POST lands*: the row would read done
  before the server holds the file; a close that then failed would flip
  a done row to error in manual mode, and in auto mode would leave it
  done through a failed batch. `done` keeps meaning "the server has
  finished this file".

### Progress at the split

When the POST resolves the file's counter is settled at `file.size`, as
now, and a checkpoint *naming the file* is reported at that count. The
row then reads 100% and `uploading` until its close marks it done, which
is the honest state — and the checkpoint is what guarantees the 100%: the
settle exists because a file's last XHR progress event may never arrive,
and without a checkpoint such a row would sit short of 100% for as long
as its close takes. Today's checkpoint there is batch-only because it
followed `onFileDone`, and naming the file would have put a done row back
under way; at the split `onFileDone` has not fired, so that reason is
gone.

The batch fraction in that checkpoint may already be 1 when the last
POST lands, before any close settles: the fraction counts bytes on the
server. That is already how it behaves — a file's counter reaches
`file.size` through XHR progress events before its close — so the
progress requirement's scenario is reworded to say the fraction reaches
1 when the last byte lands, with the final fileless `batch: 1`
checkpoint still coming after the join, so the batch-level "complete"
signal and the value keep their relative order.

### Failure with closes outstanding

- A POST failure while closes are pending: `#fail` aborts the in-flight
  XHRs and sets `#finished`; the pending closes resolve or reject later
  into an idempotent `#fail`/no-op. Server-side those jobs close normally
  and their slots are set; no payload is sent, so nothing observes them
  — exactly what already happens when a sibling's close is in flight at
  failure time today.
- A close failure after every POST has landed: reported from the close's
  own catch, so it is not held behind a sibling close that never settles.
  The batch fails and `onError` names that file. Row marking is the
  existing mid-batch contract: manual mode marks only the named row,
  auto mode marks it and every sibling not yet done, and rows whose
  closes had already resolved stay done. The R-side `file_upload_error()`
  payload names no file for a transfer failure, as now. This is the
  scenario the harness gains.
- A close that hangs (dropped socket): the join never settles and
  `run()` stays pending — the same pending `run()` the parallel-uploads
  design accepted, and why nothing user-facing awaits `run()` itself.
  The component's batch promise is settled from the callbacks, so its
  behavior on a dropped socket is unchanged.

### Cancel with closes outstanding

`cancel()` → `#stop()` aborts in-flight XHRs; the pending closes are not
cancellable (Shiny has no abort for a request) and complete server-side,
setting their slots. `#transfer` keeps its post-POST `#isStopped()`
check, so no *new* close starts after a cancel, and `run()` returns on
its stop check before the join, so no payload follows. Today's cancel
with a close in flight behaves the same; what changes is that a dead
batch can leave every slot set rather than at most the pool's worth, so
the `#stop()` comment's reason ("no `uploadEnd` runs for a stopped file,
so its slot stays empty") is no longer why no value is delivered — the
stop check before `#finish` is, and was. That comment is rewritten.

Batches on one input can now overlap on the wire: a manual-mode retry
after a cancel or failure starts batch B while A's detached closes are
still queued on R. Slot positions stay safe to reuse because every
message rides the one WebSocket in send order and R answers them on one
thread: A's `uploadEnd` for slot *i* was sent before B's, so B's value
overwrites A's before B's payload — sent only after B's own closes
resolve — is read. Slots above B's count may hold A's stale rows; the
handler reads only `1..n`. The `slotId` comment, which rests on "batches
never overlap for one input", is rewritten to state this ordering
argument instead.

### Harness: a deferrable request plan

`__requestPlan` gains `{defer: true}`, which parks the request's
`onSuccess`/`onError` pair on `window.__deferredRequests` the way
`__postPlan`'s `defer` parks XHRs.

The slot-release test defers every `uploadEnd`, uploads
`UPLOAD_CONCURRENCY + 1` files, lands the first `UPLOAD_CONCURRENCY`
POSTs and asserts the last file's POST has been issued. Holding a single
close would prove nothing: under the current code the other workers
drain the queue past it and every POST is issued anyway. With every
close held the current code parks all its workers and the POST count
stays at the limit — that is the mutation check. The same test then
releases all but one close and asserts nothing has finished, releases
the last and asserts one finish with every close recorded: the "delivery
waits for the last job to close" scenario.

The failure scenario defers every close, lands every POST, then errors
one close while the others stay parked: the error is reported at once,
naming that file, with nothing finished. The cancel scenario lands every
POST with closes parked, cancels, releases the closes, and asserts no
finish and no `onFileDone`; a second batch on the same input then
delivers with its payload following its own closes. The existing
hung-close test (a POST failing while a sibling's `uploadEnd` hangs)
stays and must stay green: the failure still reports from the worker's
catch, which the detached closes do not gate.

### End to end: an ordering assertion, not a timing probe

The bead was diagnosed with a timing probe — an unthrottled link, two
40 MB files among small ones, intervals read off by hand — and that is
why it hid: its numbers depend on the machine. The guarantee underneath
is ordering, and ordering is deterministic. With the split, a queued
file's POST is issued synchronously when a predecessor's POST lands,
while that predecessor's job close needs at least one WebSocket round
trip; so the queued POST is always issued before *any* job in the batch
has closed. Without the split a queued POST could only follow a resolved
close. The test asserts that order and holds on any link speed, with
files of any size.

It lives in `tests/testthat/test-file-e2e.R` on the existing
shinytest2/chromote layer — the only layer with a real Shiny server,
which is what answers the closes and what the bead was about. Before
the upload, `run_js` installs a recorder in the page that wraps
`Shiny.shinyapp.makeRequest` (the uploader reads the instance at
`run()`, so an instance-level wrap is enough) to log each `uploadEnd`'s
issue and answer, and `XMLHttpRequest.prototype.open`/`send` to log each
POST's issue by url. The batch is `UPLOAD_CONCURRENCY + 1` small files
through the auto-mode input. After delivery the test reads the log back
and asserts that the last file's POST was issued before the first
`uploadEnd` was answered, and that the value arrived with every row. The
same recorder, run by hand with large files, yields the intervals the
bead measured — the demonstration is available, but it is no longer the
acceptance.

## Risks / Trade-offs

- [More job closes outstanding at once than the concurrency limit] → the
  closes are tiny WebSocket messages queued on R; total work is
  unchanged and R already serializes them. No bound is needed.
- [A row can sit at 100% `uploading` for as long as the close takes] →
  that is the state it was already in; the difference is that the slot
  behind it is now doing work.
- [Two async lists to reason about — workers and closes] → both are
  joined by the same `run()` in sequence, and the failure path does not
  depend on either join settling. Covered by the existing hung-close test
  and the close-failure scenario.

## Migration Plan

No wire or R-side change; the rebuilt bundle is the whole deployment.

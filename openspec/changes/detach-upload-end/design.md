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
chain is `uploadEnd → onFileDone`, with a catch that reports through
`#fail(message, file)` and never rejects, so the list is safe to join
with `Promise.all`.

`run()` awaits `#transferAll` (every POST landed or the batch stopped),
then awaits the join (every job closed), then checks `#isStopped()`,
reports the final checkpoint and finishes. The payload therefore still
leaves after the last `uploadEnd` resolves — the ordering fact the R
handler relies on — and the R comment stating it stays true.

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
now, and the batch-only checkpoint (`file: null`) is reported then — a
file's bytes are on the server, which is what the batch fraction counts.
No file-naming checkpoint follows: the row is at 100% and `uploading`
until its close marks it done, which is the honest state. The final
`batch: 1` checkpoint still comes after the join, so the batch-level
"complete" signal and the value keep their relative order.

### Failure with closes outstanding

- A POST failure while closes are pending: `#fail` aborts the in-flight
  XHRs and sets `#finished`; the pending closes resolve or reject later
  into an idempotent `#fail`/no-op. Server-side those jobs close normally
  and their slots are set; no payload is sent, so nothing observes them
  — exactly what already happens when a sibling's close is in flight at
  failure time today.
- A close failure after every POST has landed: reported from the close's
  own catch, so it is not held behind a sibling close that never settles.
  The batch fails; the failed file's row is the one marked. This is the
  scenario the harness gains.
- A close that hangs (dropped socket): the join never settles and
  `run()` stays pending — the same pending `run()` the parallel-uploads
  design accepted, and why nothing user-facing awaits `run()` itself.
  The component's batch promise is settled from the callbacks, so its
  behavior on a dropped socket is unchanged.

### Cancel with closes outstanding

`cancel()` → `#stop()` aborts in-flight XHRs; the pending closes are not
cancellable (Shiny has no abort for a request) and complete server-side.
`#transfer` keeps its post-POST `#isStopped()` check, so no *new* close
starts after a cancel. The join is never reached because `run()` checks
`#isStopped()` before delivering. Same as today's cancel with a close in
flight.

### Harness: a deferrable request plan

`__requestPlan` gains `{defer: true}`, which parks the request's
`onSuccess`/`onError` pair on `window.__deferredRequests` the way
`__postPlan`'s `defer` parks XHRs. The slot-release test holds the first
file's close open with more files than the limit, asserts every POST has
been issued (the queue advanced past the held close), then releases it
and asserts the batch finishes once with all closes recorded. Against
the current code the queue stalls at the limit and the test fails, which
is the mutation check. The failure and cancel scenarios above use the
same hook.

The timing probe that diagnosed the bead (unthrottled link, two 40 MB
files among small ones, POST and `uploadEnd` intervals logged from the
component's events) is the acceptance demonstration: rerun it after the
fix and record the intervals in the bead. It is a probe, not a committed
test — its numbers depend on the machine.

## Risks / Trade-offs

- [More job closes outstanding at once than the concurrency limit] → the
  closes are tiny WebSocket messages queued on R; total work is
  unchanged and R already serializes them. No bound is needed.
- [A row can sit at 100% `uploading` for as long as the close takes] →
  that is the state it was already in; the difference is that the slot
  behind it is now doing work.
- [Two async lists to reason about — workers and closes] → both are
  joined by the same `run()` in sequence, and the failure path does not
  depend on either join settling. Covered by the hung-close test.

## Migration Plan

No wire or R-side change; the rebuilt bundle is the whole deployment.

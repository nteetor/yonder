# Detach uploadEnd from the pool slot

Bead: yonder-c7j

## Why

The upload pool frees a file's slot when the server has *closed its job*
(`uploadEnd` returns), not when the file's *bytes have landed* (its POST
resolves). Closing a job is answered on R's single thread, which during a
batch is also ingesting every other in-flight body, so on a fast link with
large files the close stretches from ~6 ms to 50–105 ms and only drains
when the large transfer finishes. Small files then finish their POSTs and
sit holding their slots; the next queued file does not start until the
first large file lands. That is the head-of-line blocking the
parallel-uploads design said the pool avoids ("no barrier — a finished
small file's job closes while a large one still transfers"): the design
stated it, the implementation released the slot one step too late.
Throttled links hide the defect, which is why it survived the change's
own e2e coverage.

## What Changes

- A pool slot is released when a file's POST resolves. The job close
  (`uploadEnd`) runs detached from the slot: the worker moves to the next
  queued file without waiting for it.
- The batch's completion still waits for every job to close: the batch
  payload is sent only after the last `uploadEnd` has resolved, so the
  server-side ordering guarantee the `bsides.file.batch` handler relies on
  ("every slot is set before the payload arrives") is unchanged.
- Failure and cancel contracts are unchanged: a job close that fails
  after its bytes landed still fails the whole batch, and a cancel with
  job closes outstanding delivers no value. A file's row is marked done
  when its job closes, as now — not when its bytes land.
- No public R API, no markup attribute, no wire-protocol change. The
  concurrency limit stays internal.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `file-upload`: the concurrency requirement gains the point at which a
  slot frees (bytes landed, not job closed); the value-delivery and
  failure requirements each gain a scenario for the window between the
  last bytes landing and the last job closing.

## Impact

- `srcts/src/components/upload.ts` — the per-file transfer chain splits
  at the POST: slot release, a detached `uploadEnd` per file collected
  for a join before the deliver phase, failure reporting from the
  detached chain. The header comment and the "No barrier between files"
  comment above `#transfer` describe behavior the code did not have;
  both are rewritten.
- `srcts/tests/test-bindings.mjs` — the scripted `makeRequest` gains a
  deferrable plan, so a test can hold a job close open, assert that the
  queue advanced past it, then release it and assert delivery.
- `srcts/src/components/webcomponents/file.ts`, `R/input-file.R` — no
  change expected; the callbacks' shape and the batch payload's timing
  relative to the last `uploadEnd` are preserved. Listed because both
  hold comments describing that timing, which must remain true.
- Bundles under `inst/www/yonder/js/` rebuilt.
- `inst/examples-shiny/input-file/app.R` — the Progress card is where
  the defect was observed; its prose already describes the intended
  behavior and needs no change.

# file-upload delta: detach uploadEnd from the pool slot

## MODIFIED Requirements

### Requirement: Files in a batch upload concurrently

A batch's files SHALL transfer concurrently, up to a bounded concurrency
limit; files beyond the limit queue and start as slots free. A slot SHALL
free when its file's bytes have landed on the server, not when the server
has finished closing that file's job, so a queued file's transfer starts
as soon as any in-flight transfer completes regardless of how long the
server takes to close it. A batch of one file SHALL behave exactly as
before. The limit is internal — no public API or markup attribute
configures it.

#### Scenario: Small-file batch is not serialized

- **WHEN** a batch of many small files uploads
- **THEN** more than one file is in flight at a time, so total time is
  not the sum of per-file round trips

#### Scenario: Concurrency is bounded

- **WHEN** a batch holds more files than the concurrency limit
- **THEN** at most the limit's worth of transfers are in flight at once
  and every file still uploads exactly once

#### Scenario: A queued file starts when a predecessor's bytes land

- **WHEN** a batch holds more files than the concurrency limit and the
  server is slow to close finished jobs
- **THEN** the next queued file's transfer starts as soon as an in-flight
  transfer's bytes have landed, before the server has closed that job

### Requirement: Batch value is delivered once, in declared order

A completed batch SHALL set `input$<id>` exactly once, to a data frame
with columns `name`, `size`, `type`, and `datapath`, one row per file,
in the order the files were staged/selected — regardless of the order in
which transfers happened to finish. Each file's content SHALL land in
the `datapath` row bearing that file's `name`, `size`, and `type`. The
value SHALL NOT be delivered until the server has closed every file's
job.

#### Scenario: Completion order does not reorder or scramble the value

- **WHEN** a later-declared small file finishes before an earlier-declared
  large one
- **THEN** `input$<id>` rows are still in declared order and each row's
  `datapath` holds the bytes of the file its `name` describes

#### Scenario: One invalidation per batch

- **WHEN** a batch of N files completes
- **THEN** observers of `input$<id>` fire once, seeing all N rows — never
  a partial batch

#### Scenario: Consecutive identical batches both deliver

- **WHEN** the same set of files is uploaded twice in a row
- **THEN** the second batch also sets `input$<id>` (client-side value
  deduplication does not swallow it)

#### Scenario: Delivery waits for the last job to close

- **WHEN** every file's bytes have landed but the server has not yet
  closed every file's job
- **THEN** `input$<id>` is not yet set, and is set exactly once after the
  last job closes

### Requirement: Batch failure is atomic

Any file's transfer failure SHALL fail the whole batch: remaining
transfers are aborted, `input$<id>` is not set, and the input reports the
failure through its existing status/error contract (`status = "failed"`,
`file_upload_error()` returns a `bsides_file_failure`). A failure to
close a file's job after its bytes have landed is a transfer failure of
that file. Mode-specific aftermath is unchanged: manual mode returns the
set to staged, ready to retry; auto mode's failure is terminal for the
gesture.

#### Scenario: Mid-batch failure with transfers in flight

- **WHEN** one file's transfer fails while others are in flight or queued
- **THEN** in-flight transfers are aborted, queued ones never start, no
  value reaches `input$<id>`, and status lands on `"failed"`

#### Scenario: Oversize file fails before any bytes move

- **WHEN** a batch contains a file over `shiny.maxRequestSize`
- **THEN** the batch fails during initialization and no file's bytes are
  posted

#### Scenario: A job close fails after every file's bytes have landed

- **WHEN** the server rejects closing a file's job after all transfers
  have completed
- **THEN** the batch fails, that file is the one reported as failed, no
  value reaches `input$<id>`, and the failure is reported without waiting
  on any other job close that has not settled

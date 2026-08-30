# file-upload delta: parallel uploads

## Purpose

The file input's upload transport contract: how a confirmed batch of
files moves from the browser to `input$<id>` — concurrency, value
delivery, progress aggregation, and failure/cancel atomicity — in both
auto and manual upload modes.

## ADDED Requirements

### Requirement: Files in a batch upload concurrently

A batch's files SHALL transfer concurrently, up to a bounded concurrency
limit; files beyond the limit queue and start as slots free. A batch of
one file SHALL behave exactly as before. The limit is internal — no
public API or markup attribute configures it.

#### Scenario: Small-file batch is not serialized

- **WHEN** a batch of many small files uploads
- **THEN** more than one file is in flight at a time, so total time is
  not the sum of per-file round trips

#### Scenario: Concurrency is bounded

- **WHEN** a batch holds more files than the concurrency limit
- **THEN** at most the limit's worth of transfers are in flight at once
  and every file still uploads exactly once

### Requirement: Batch value is delivered once, in declared order

A completed batch SHALL set `input$<id>` exactly once, to a data frame
with columns `name`, `size`, `type`, and `datapath`, one row per file,
in the order the files were staged/selected — regardless of the order in
which transfers happened to finish. Each file's content SHALL land in
the `datapath` row bearing that file's `name`, `size`, and `type`.

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

### Requirement: Batch failure is atomic

Any file's transfer failure SHALL fail the whole batch: remaining
transfers are aborted, `input$<id>` is not set, and the input reports the
failure through its existing status/error contract (`status = "failed"`,
`file_upload_error()` returns a `bsides_file_failure`). Mode-specific
aftermath is unchanged: manual mode returns the set to staged, ready to
retry; auto mode's failure is terminal for the gesture.

#### Scenario: Mid-batch failure with transfers in flight

- **WHEN** one file's transfer fails while others are in flight or queued
- **THEN** in-flight transfers are aborted, queued ones never start, no
  value reaches `input$<id>`, and status lands on `"failed"`

#### Scenario: Oversize file fails before any bytes move

- **WHEN** a batch contains a file over `shiny.maxRequestSize`
- **THEN** the batch fails during initialization and no file's bytes are
  posted

### Requirement: Cancel aborts the whole batch

Cancelling an uploading batch SHALL abort every in-flight transfer,
start no queued ones, and deliver no value. Existing mode semantics are
unchanged: manual mode lands back on the staged set; auto mode's cancel
is terminal.

#### Scenario: Cancel with several transfers in flight

- **WHEN** the user cancels while multiple files are mid-transfer
- **THEN** all in-flight requests are aborted, no queued transfer starts,
  and `input$<id>` is never set for that batch

### Requirement: Progress reporting survives interleaving

Per-file progress SHALL continue to report each file's own fraction, and
the batch fraction SHALL be the monotone ratio of bytes sent (across all
in-flight and completed files) to total batch bytes. The
`bsides-file:progress` event and the `file_upload_progress()` reader keep
their existing shapes and ranges.

#### Scenario: Aggregate progress with concurrent transfers

- **WHEN** multiple files report progress interleaved
- **THEN** the batch fraction never decreases and reaches 1 exactly when
  the batch completes

#### Scenario: Per-file rows track their own file

- **WHEN** two files are mid-transfer at once
- **THEN** each file's list row reflects that file's own progress, not a
  blend

### Requirement: Form submission still waits for the batch

Inside `input_form()`, a manual-mode input's batch started by a submit
SHALL complete its value delivery before the form's own value is sent,
so observers gated on the form submit read the uploaded files. A failed
or cancelled batch SHALL still abort the form submission as it does
today.

#### Scenario: Submit reads the delivered batch

- **WHEN** a form submit triggers a staged upload and the batch completes
- **THEN** by the time `input$<form-id>` fires, `input$<file-id>` already
  holds the batch's data frame

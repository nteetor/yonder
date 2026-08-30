#' File input
#'
#' Upload files to the server. By default files upload as soon as they
#' are chosen; with `upload_mode = "manual"` they accumulate in a staged
#' set, each removable, until an explicit action starts the batch. A
#' progress bar tracks a batch in flight and a cancel control abandons
#' it.
#'
#' @inheritParams input_checkbox
#'
#' @param label A character string. The label of the input, rendered as
#'   the legend of the fieldset wrapping the input.
#'
#' @param select A character string. With `"one"` (default) a single file
#'   may be chosen, with `"many"` any number.
#'
#' @param upload_mode A character string. With `"auto"` (default) files
#'   upload as soon as they are chosen. With `"manual"` files accumulate
#'   in a staged set — each removable before flight, a same-named
#'   addition replacing its predecessor — and an explicit action starts
#'   the batch: the input's Upload button, a surrounding
#'   [input_form()]'s submit, or [file_upload_start()] from the server.
#'   A cancelled or failed batch returns to the staged set, ready to
#'   retry whole.
#'
#' @param upload_button A character string. With `"show"` (default) a
#'   manual-mode input renders its own Upload button; with `"none"` it
#'   does not, leaving the batch to an app-supplied trigger —
#'   [file_upload_start()], or a surrounding [input_form()], whose
#'   submit already starts it. With the button hidden and neither of
#'   those in place, nothing visible starts the batch. The cancel
#'   control still appears while a batch is in flight. Ignored in auto
#'   mode, which has no Upload button.
#'
#' @param upload_max A whole number bounding how many files one batch
#'   may contain, defaults to `NULL`, no bound.
#'
#'   In manual mode, the staged set counts toward the bound and the input stops
#'   accepting files once full — remove a file to make room. Delivered rows do
#'   not count: they are not part of the next batch. A file with the same name
#'   as a staged one replaces it rather than adding, so a replacing drop passes
#'   even at the bound.
#'
#'   In auto mode, and for drops and pastes that would overfill a staged set, a
#'   gesture selecting too many files is rejected whole rather than trimmed —
#'   quietly keeping part of a selection would read as data loss. With `select =
#'   "one"` a single file is already the bound.
#'
#' @param accept A character vector of file extensions (`".csv"`), MIME
#'   types (`"text/csv"`), or MIME wildcards (`"image/*"`) bounding what
#'   may be chosen, defaults to `NULL`, in which case any file may be
#'   chosen.
#'
#' @param capture A character string, one of `"user"` or `"environment"`,
#'   asking a mobile browser to capture a new photo or video with the
#'   front or rear camera instead of browsing existing files. Defaults to
#'   `NULL`, browse only.
#'
#' @param placeholder A character string. The prompt shown inside the drop
#'   zone, defaults to `"Choose a file"`.
#'
#' @param summary A character string, a template for the file list's
#'   summary line, defaults to `NULL`, in which case
#'   `"{files} · {size}"` applies. Tokens are replaced from upload state:
#'
#'   * `{files}`, the pluralized file count, "3 files".
#'   * `{n}`, the bare file count, "3".
#'   * `{size}`, the total size of the batch, "2.0 MB".
#'   * `{done}`, the number of files uploaded so far.
#'   * `{failed}`, the number of files that failed.
#'   * `{percent}`, the batch progress as a whole number, "63".
#'
#'   Unknown tokens are left as-is. The summary stays visible while the
#'   file list is collapsed, so the state tokens can make it a compact
#'   status line, e.g. `"{done}/{n} uploaded"`.
#'
#' @param height A character string, a CSS length setting the minimum
#'   height of the drop zone, defaults to `NULL`, in which case the drop
#'   zone is twice the height of a standard input. Any CSS length works:
#'   `"12rem"`, `"200px"`, `"clamp(6rem, 20vh, 16rem)"`. A theme may set
#'   the default for every file input through the
#'   `--bsides-file-dropzone-height` CSS variable; `height` overrides the
#'   theme for its input.
#'
#' @details
#'
#' ## Uploading
#'
#' Uploaded bytes travel over HTTP rather than the app's websocket
#' connection, so the session stays responsive while an upload is in
#' flight — a long upload does not block reactivity, and the R process
#' does work only when a batch begins and ends.
#'
#' ## Server value
#'
#' A data frame with one row per uploaded file and the columns `name`,
#' `size`, `type`, and `datapath` — the same contract as
#' [shiny::fileInput()], because the server side of the upload protocol
#' produces it. `datapath` points at a temporary file owned by the
#' session; copy anything you need to keep.
#'
#' The value is `NULL` until the first upload completes. Re-rendering the
#' input (through [shiny::renderUI()], say) resets it to `NULL`, again as
#' with [shiny::fileInput()].
#'
#' ## Upload size
#'
#' Shiny caps uploads at `getOption("shiny.maxRequestSize")`, 5 MB by
#' default, and rejects a batch if any one file exceeds it. Raise it for
#' larger uploads:
#'
#' ```r
#' options(shiny.maxRequestSize = 30 * 1024^2)
#' ```
#'
#' The limit is read at render time to pre-validate on the client, and
#' enforced again by the server on every upload.
#'
#' ## Inside a form
#'
#' [input_form()] holds an input's value back until the form is
#' submitted. An auto-mode file input is not held back: its value is set
#' by the server when the upload finishes, not by a client-side input
#' change, so it lands as soon as the upload does — before the form is
#' submitted, not with it.
#'
#' `upload_mode = "manual"` is the answer inside a form. Files stage
#' while the form is filled in, the batch starts when the form submits,
#' and the form holds its own value back until that upload finishes. So
#' an observer keyed on the submit sees the uploaded files:
#'
#' ```r
#' observeEvent(input$form_id, {
#'   files <- input$file_id
#' })
#' ```
#'
#' The submit button shows a pending state while it waits; an app that
#' wants its own indicator can read [file_upload_progress()]. If the
#' upload fails, or the user cancels it, the form is not submitted at
#' all — nothing is sent, the staged files are kept, and submitting
#' again retries them.
#'
#' ## Known limitations
#'
#' Bookmarking saves an uploaded file, but restoring a bookmark does not
#' re-populate the input. Whole directories cannot be uploaded: the
#' protocol carries bare file names, so the paths within a directory
#' would not survive.
#'
#' @inherit input_checkbox_group return
#'
#' @family inputs
#'
#' @seealso [update_file()], [reset_file()], [file_upload_start()]
#'
#' @export
input_file <-
  function(
    id,
    ...,
    label = NULL,
    select = c("one", "many"),
    upload_mode = c("auto", "manual"),
    upload_button = c("show", "none"),
    upload_max = NULL,
    accept = NULL,
    capture = NULL,
    placeholder = NULL,
    summary = NULL,
    height = NULL
  ) {
    check_string(id, allow_empty = FALSE)
    select <- arg_match(select)
    upload_mode <- arg_match(upload_mode)
    upload_button <- arg_match(upload_button)
    check_number_whole(upload_max, allow_null = TRUE)
    check_character(accept, allow_null = TRUE)
    check_string(placeholder, allow_null = TRUE)
    check_string(summary, allow_null = TRUE)
    check_css_length(height, allow_null = TRUE)

    if (non_null(capture)) {
      capture <- arg_match(capture, c("user", "environment"))
    }

    args <- list2(...)
    attrs <- keep_named(args)

    htmltools::tag(
      "bsides-file",
      list2(
        id = id,
        multiple = if (select == "many") NA,
        mode = if (upload_mode == "manual") upload_mode,
        button = if (upload_button == "none") upload_button,
        max = if (non_null(upload_max)) upload_max,
        accept = if (non_null(accept)) paste0(accept, collapse = ","),
        capture = capture,
        placeholder = placeholder,
        summary = summary,
        # A render-time mirror of the server's limit, letting the client
        # reject an oversize file before it costs a round trip. The
        # server enforces the option in force at upload time regardless.
        `data-max-size` = format_no_sci(file_max_size()),
        !!!attrs
      )
    ) |>
      tag_style_add(`--bsides-file-dropzone-height` = height) |>
      wrap_label(label, wrapper = "fieldset") |>
      dependency_append() |>
      s3_class_add("bsides_file")
  }

#' Update a file input
#'
#' Update the properties of an [input_file()]: what it accepts, its
#' prompt and summary line, and its enabled state. The upload arguments
#' (`upload_mode`, `upload_button`, `upload_max`) are fixed at render
#' time and cannot be updated. The value is never set from the server —
#' the upload protocol writes it as a batch completes, and offers no
#' way to set or unset it.
#'
#' @inheritParams input_file
#'
#' @param ... These dots are for future extensions and must be empty.
#'
#' @param accept A character vector. The new bound on what may be
#'   chosen, as file extensions (`".csv"`), MIME types (`"text/csv"`),
#'   or MIME wildcards (`"image/*"`).
#'
#' @param placeholder A character string. The new prompt shown inside
#'   the drop zone.
#'
#' @param summary A character string. The new template for the file
#'   list's summary line; see [input_file()] for the tokens.
#'
#' @param enable If `TRUE`, enable the input.
#'
#' @param disable If `TRUE`, disable the input. When both `enable` and
#'   `disable` are `TRUE`, `disable` wins.
#'
#' @param session A shiny session object.
#'
#' @returns No return value, called for side effects.
#'
#' @seealso [input_file()], [reset_file()]
#'
#' @export
update_file <-
  function(
    id,
    ...,
    accept = NULL,
    placeholder = NULL,
    summary = NULL,
    enable = NULL,
    disable = NULL,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)
    check_character(accept, allow_null = TRUE)
    check_string(placeholder, allow_null = TRUE)
    check_string(summary, allow_null = TRUE)
    check_bool(enable, allow_null = TRUE)
    check_bool(disable, allow_null = TRUE)

    msg <-
      drop_nulls(list(
        accept = if (non_null(accept)) paste0(accept, collapse = ","),
        placeholder = placeholder,
        summary = summary,
        enable = enable,
        disable = disable
      ))

    session$sendInputMessage(id, msg)
  }

#' Reset a file input
#'
#' Clear an [input_file()]'s file list, progress, and any error; a
#' batch in flight is cancelled. The server value is left as it is —
#' the upload protocol has no way to unset it.
#'
#' @inheritParams update_file
#'
#' @returns No return value, called for side effects.
#'
#' @seealso [input_file()], [update_file()]
#'
#' @export
reset_file <-
  function(
    id,
    ...,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)

    session$sendInputMessage(id, list(reset = TRUE))

    invisible(NULL)
  }

#' File upload actions and state
#'
#' Drive a file input's upload from the server, and read its upload
#' state ahead of the value — `input$<id>` is set once per batch, when
#' an upload completes, and is `NULL` before the first; everything in
#' between lives here.
#'
#' The actions:
#'
#' * `file_upload_start()` starts the staged batch of an
#'   `upload_mode = "manual"` input — the server-side twin of its
#'   Upload button. A no-op when nothing is staged or a batch is
#'   already in flight.
#' * `file_upload_cancel()` abandons the batch in flight, landing where
#'   the Cancel button lands: in manual mode the rows return to the
#'   staged set, ready to retry; in auto mode the cancel is terminal —
#'   unfinished rows keep a failure mark and the status reads
#'   `"cancelled"`. A no-op when nothing is in flight.
#'
#' The readers:
#'
#' * `file_upload_status()` returns one of `"idle"` (no files),
#'   `"staged"` (a set awaits its upload), `"uploading"`, `"done"` (the
#'   batch delivered), `"failed"` (the set is retained in manual mode,
#'   ready to retry), or `"cancelled"` (auto mode; in manual mode a
#'   cancel lands back in `"staged"`).
#' * `file_upload_progress()` returns the batch fraction in `[0, 1]`.
#' * `file_upload_staged()` returns the staged set as a data frame of
#'   `name`, `size`, and `type` — the value's columns before there are
#'   paths — with zero rows when nothing is staged.
#' * `file_upload_error()` returns the last failure as a condition
#'   object, or `NULL`. `conditionMessage()` is the headline; `$files`
#'   is a data frame of `name`, `reason`, and `limit`, one row per
#'   rejected file, with zero rows when the failure names no file. The
#'   class says what happened:
#'
#'   * `bsides_file_rejection` — nothing was attempted; in manual mode
#'     the staged set is intact.
#'   * `bsides_file_failure` — a batch started and died in transport.
#'   * `bsides_file_error` — the base class both inherit from, for
#'     code that does not care which.
#'
#'   The `reason` codes are the stable surface — the message text is
#'   written for display and may be reworded:
#'
#'   * `"size"` — the file is over the per-file upload limit.
#'   * `"accept"` — the file does not match `accept`.
#'   * `"directory"` — a dropped folder, which cannot be uploaded.
#'   * `"multiple"` — a multi-file gesture on a `select = "one"` input;
#'     recorded against every file in the gesture.
#'   * `"count"` — a gesture past `upload_max`; likewise recorded
#'     against every file in the gesture.
#'
#'   The reader returns to `NULL` on any edit of the staged set, a new
#'   batch, or [reset_file()].
#'
#' Each reader is a reactive read of a companion input pushed by the
#' component, so an observer or reactive using one invalidates only
#' when that facet changes. Use them to drive an app's own controls —
#' enable a submit while `nrow(file_upload_staged(id)) > 0`, render a
#' progress line from `file_upload_progress(id)` — including inside
#' [input_form()], whose input freeze does not hold them back.
#'
#' @inheritParams update_file
#'
#' @return The actions return `NULL`, invisibly; the readers as
#'   described above.
#'
#' @seealso [input_file()], [update_file()]
#'
#' @export
file_upload_start <-
  function(
    id,
    ...,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)

    session$sendInputMessage(id, list(upload_start = TRUE))

    invisible(NULL)
  }

#' @rdname file_upload_start
#'
#' @export
file_upload_cancel <-
  function(
    id,
    ...,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)

    session$sendInputMessage(id, list(upload_cancel = TRUE))

    invisible(NULL)
  }

#' @rdname file_upload_start
#'
#' @export
file_upload_status <-
  function(
    id,
    ...,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)

    session$input[[paste0(id, "__bsides_status")]] %||% "idle"
  }

#' @rdname file_upload_start
#'
#' @export
file_upload_progress <-
  function(
    id,
    ...,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)

    session$input[[paste0(id, "__bsides_progress")]] %||% 0
  }

#' @rdname file_upload_start
#'
#' @export
file_upload_staged <-
  function(
    id,
    ...,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)

    session$input[[paste0(id, "__bsides_staged")]] %||% file_staged_frame()
  }

#' @rdname file_upload_start
#'
#' @export
file_upload_error <-
  function(
    id,
    ...,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)

    session$input[[paste0(id, "__bsides_error")]]
  }

file_staged_frame <-
  function(
    name = character(),
    size = numeric(),
    type = character()
  ) {
    data.frame(name = name, size = size, type = type, row.names = NULL)
  }

file_staged_input_type <- "bsides.file.staged"

file_staged_input_register_handler <-
  function() {
    shiny::registerInputHandler(
      file_staged_input_type,
      function(
        value,
        session,
        name
      ) {
        if (length(value) < 1) {
          return(file_staged_frame())
        }

        file_staged_frame(
          name = vapply(value, \(f) f$name, character(1)),
          size = vapply(value, \(f) as.numeric(f$size), numeric(1)),
          type = vapply(value, \(f) f$type %||% "", character(1))
        )
      },
      force = TRUE
    )
  }

file_batch_input_type <- "bsides.file.batch"

# Mirrors `slotId()` in srcts/src/components/upload.ts: each file's
# `uploadEnd` finishes its job into `<id>__bsides_slot_<position>`, 1-based
# by declared position. Derived here rather than read off the payload so
# the batch's membership and order are the server's to decide.
file_batch_slot_id <-
  function(name, index) {
    paste0(name, "__bsides_slot_", index)
  }

# Shiny's FileUploadOperation names each file by its index within its
# upload job, so one job per file writes every file as `0.<ext>`. App code
# keyed on `basename(datapath)` — the common `file.copy()` pattern — would
# collapse a same-extension batch onto one name. Renaming by batch
# position restores the `0.csv`, `1.csv`, ... basenames a single-job upload
# produced. Every job owns a private directory, so the targets cannot
# collide across files. A file that will not move keeps its datapath: a
# shared basename beats a value pointing at nothing.
file_batch_rename_datapath <-
  function(frame) {
    from <- frame$datapath
    to <- vapply(
      seq_along(from),
      \(i) {
        file.path(
          dirname(from[[i]]),
          sub("^[0-9]+", i - 1L, basename(from[[i]]))
        )
      },
      character(1)
    )

    movable <- from != to & file.exists(from) & !file.exists(to)
    from[movable] <- ifelse(
      file.rename(from[movable], to[movable]),
      to[movable],
      from[movable]
    )

    frame$datapath <- from

    frame
  }

# Assembles a completed batch's value from the per-slot companion inputs
# that the client's per-file `uploadEnd` calls filled. The payload carries
# only a count, so nothing the client sends is dereferenced. Slot inputs
# are always set before it arrives — the client sends it only once every
# `uploadEnd` has resolved, and the socket delivers in order — so a missing
# slot means a restored bookmark, not a race, and yields NULL rather than
# an error.
file_batch_input_register_handler <-
  function() {
    shiny::registerInputHandler(
      file_batch_input_type,
      function(
        value,
        session,
        name
      ) {
        # A payload that is not an object at all still has to degrade to
        # NULL: `$` on an atomic vector errors, and this runs inside input
        # dispatch where an error takes the session down.
        n <- if (is.list(value)) value$n

        if (!rlang::is_scalar_integerish(n) || is.na(n) || n < 1) {
          return(NULL)
        }

        slot <- function(index) {
          shiny::isolate(session$input[[file_batch_slot_id(name, index)]])
        }

        # Every slot must be set, so testing the last one first settles a
        # bookmark restore, and bounds the work an implausible `n` can ask
        # for, before allocating anything of that size.
        if (is.null(slot(n))) {
          return(NULL)
        }

        frames <- lapply(seq_len(n), slot)

        if (any(vapply(frames, is.null, logical(1)))) {
          return(NULL)
        }

        frame <- do.call(rbind, frames)
        row.names(frame) <- NULL

        file_batch_rename_datapath(frame)
      },
      force = TRUE
    )
  }

file_error_frame <-
  function(
    name = character(),
    reason = character(),
    limit = numeric()
  ) {
    data.frame(name = name, reason = reason, limit = limit, row.names = NULL)
  }

file_error_input_type <- "bsides.file.error"

file_error_input_register_handler <-
  function() {
    shiny::registerInputHandler(
      file_error_input_type,
      function(
        value,
        session,
        name
      ) {
        if (length(value) < 1) {
          return(NULL)
        }

        file_error_condition(value)
      },
      force = TRUE
    )
  }

# Builds the condition file_upload_error() returns from the payload the
# component pushes: kind picks the class, the client-rendered sentences
# become the message, the per-file records the `files` frame. Never
# signalled, so `call` stays NULL — a fabricated condition carrying a
# call prints as though an error had been raised somewhere real.
file_error_condition <-
  function(value) {
    class <- switch(
      value$kind,
      rejection = "bsides_file_rejection",
      failure = "bsides_file_failure"
    )

    files <- value$files %||% list()

    error_cnd(
      class = c(class, "bsides_file_error"),
      message = paste(
        vapply(value$messages, \(m) m, character(1)),
        collapse = "\n"
      ),
      files = file_error_frame(
        name = vapply(files, \(f) f$name, character(1)),
        reason = vapply(files, \(f) f$reason, character(1)),
        limit = vapply(files, \(f) as.numeric(f$limit %||% NA), numeric(1))
      ),
      call = NULL
    )
  }

file_max_size <-
  function() {
    getOption("shiny.maxRequestSize", 5 * 1024^2)
  }

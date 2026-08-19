#' File input
#'
#' Upload files to the server. By default files upload as soon as they
#' are chosen; with `upload_mode = "manual"` they accumulate in a staged
#' set, each removable, until the input's Upload button starts the
#' batch. A progress bar tracks a batch in flight and a cancel control
#' abandons it.
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
#'   the batch: the input's Upload button, or [file_upload_start()] from
#'   the server. A cancelled or failed batch returns to the staged set,
#'   ready to retry whole.
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
#' change, so it lands as soon as the upload does. Prefer
#' `upload_mode = "manual"` inside a form — files stage while the form
#' is filled in, and the batch starts when the form submits, so the
#' value lands alongside the form's own (less the transfer time).
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
    accept = NULL,
    capture = NULL,
    placeholder = NULL,
    summary = NULL,
    height = NULL
  ) {
    check_string(id, allow_empty = FALSE)
    select <- arg_match(select)
    upload_mode <- arg_match(upload_mode)
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
#' prompt and summary line, and its enabled state. The value is never
#' set from the server — the upload protocol writes it as a batch
#' completes, and offers no way to set or unset it.
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
#'   staged set, ready to retry; in auto mode they are marked failed. A
#'   no-op when nothing is in flight.
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
#' * `file_upload_error()` returns the last failure's message, or
#'   `NULL`.
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
          name = vapply(value, function(f) f$name, character(1)),
          size = vapply(value, function(f) as.numeric(f$size), numeric(1)),
          type = vapply(value, function(f) f$type %||% "", character(1))
        )
      },
      force = TRUE
    )
  }

file_max_size <-
  function() {
    getOption("shiny.maxRequestSize", 5 * 1024^2)
  }

#' File input
#'
#' Upload files to the server. Files upload as soon as they are chosen —
#' over HTTP, beside the WebSocket — so the app stays responsive while
#' bytes are in transit. A progress bar tracks the batch and a cancel
#' control abandons it.
#'
#' @inheritParams input_checkbox
#'
#' @param label A character string. The label of the input, rendered as
#'   the legend of the fieldset wrapping the input.
#'
#' @param select A character string. With `"one"` (default) a single file
#'   may be chosen, with `"many"` any number.
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
#' @details
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
#' submitted. A file input is not held back: its value is set by the
#' server when the upload finishes, not by a client-side input change.
#'
#' @inherit input_checkbox_group return
#'
#' @family inputs
#'
#' @seealso [update_file()]
#'
#' @export
input_file <-
  function(
    id,
    ...,
    label = NULL,
    select = c("one", "many"),
    accept = NULL,
    capture = NULL,
    placeholder = NULL
  ) {
    check_string(id, allow_empty = FALSE)
    select <- arg_match(select)
    check_character(accept, allow_null = TRUE)
    check_string(placeholder, allow_null = TRUE)

    if (non_null(capture)) {
      capture <- arg_match(capture, c("user", "environment"))
    }

    args <- list2(...)
    attrs <- keep_named(args)

    input <-
      htmltools::tag(
        "bsides-file",
        list2(
          id = id,
          multiple = if (select == "many") NA,
          accept = if (non_null(accept)) paste0(accept, collapse = ","),
          capture = capture,
          placeholder = placeholder,
          # A render-time mirror of the server's limit, letting the client
          # reject an oversize file before it costs a round trip. The
          # server enforces the option in force at upload time regardless.
          `data-max-size` = format_no_sci(file_max_size()),
          !!!attrs
        )
      )

    input <-
      wrap_label(input, label, wrapper = "fieldset")

    input <-
      dependency_append(input)

    input <-
      s3_class_add(input, "bsides_file")

    input
  }

#' @rdname input_file
#'
#' @param reset If `TRUE`, clear the file list, progress, and any error,
#'   defaults to `NULL`. A batch in flight is cancelled. The server value
#'   is left as it is — the upload protocol has no way to unset it.
#'
#' @param enable If `TRUE`, enable the input, defaults to `NULL`.
#'
#' @param disable If `TRUE`, disable the input, defaults to `NULL`. When
#'   both `enable` and `disable` are `TRUE`, `disable` wins.
#'
#' @export
update_file <-
  function(
    id,
    ...,
    reset = NULL,
    accept = NULL,
    placeholder = NULL,
    enable = NULL,
    disable = NULL,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)
    check_bool(reset, allow_null = TRUE)
    check_character(accept, allow_null = TRUE)
    check_string(placeholder, allow_null = TRUE)
    check_bool(enable, allow_null = TRUE)
    check_bool(disable, allow_null = TRUE)

    msg <-
      drop_nulls(list(
        reset = reset,
        accept = if (non_null(accept)) paste0(accept, collapse = ","),
        placeholder = placeholder,
        enable = enable,
        disable = disable
      ))

    session$sendInputMessage(id, msg)
  }

file_max_size <-
  function() {
    getOption("shiny.maxRequestSize", 5 * 1024^2)
  }

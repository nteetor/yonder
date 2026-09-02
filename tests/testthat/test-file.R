test_that("argument `id`", {
  expect_error(input_file(), "`id`")

  expect_silent(input_file("test"))
})

test_that("`select` chooses the multiple attribute", {
  expect_no_match(format(input_file("test")), "multiple")
  expect_match(format(input_file("test", select = "many")), "multiple")

  expect_error(input_file("test", select = "all"), "select")
})

test_that("`upload_mode` chooses the mode attribute", {
  expect_no_match(format(input_file("test")), "mode=")
  expect_match(
    format(input_file("test", upload_mode = "manual")),
    'mode="manual"'
  )

  expect_error(input_file("test", upload_mode = "batch"), "upload_mode")
})

test_that("`upload_button` chooses the button attribute", {
  expect_no_match(
    format(input_file("test", upload_mode = "manual")),
    "button="
  )

  expect_match(
    format(input_file("test", upload_mode = "manual", upload_button = "none")),
    'button="none"'
  )

  expect_error(input_file("test", upload_button = "hide"), "upload_button")
})

test_that("`upload_max` renders as the max attribute", {
  expect_no_match(format(input_file("test")), " max=")

  expect_match(
    format(input_file("test", select = "many", upload_max = 3)),
    'max="3"'
  )

  expect_error(input_file("test", upload_max = "three"), "upload_max")
})

test_that("`accept` collapses to a comma-separated attribute", {
  expect_match(
    format(input_file("test", accept = c(".csv", "text/csv"))),
    'accept="\\.csv,text/csv"'
  )

  expect_no_match(format(input_file("test")), "accept=")
})

test_that("`capture` is bounded", {
  expect_error(input_file("test", capture = "camera"), "capture")

  expect_match(
    format(input_file("test", capture = "user")),
    'capture="user"'
  )
})

test_that("the upload limit renders as an attribute", {
  # The default the server itself falls back to.
  expect_match(format(input_file("test")), 'data-max-size="5242880"')

  withr::with_options(list(shiny.maxRequestSize = 1e6), {
    expect_match(format(input_file("test")), 'data-max-size="1000000"')
  })
})

test_that("`label` renders as a fieldset legend", {
  html <- format(input_file("test", label = "Upload data"))

  expect_match(html, "<fieldset")
  expect_match(html, "Upload data</legend>")
})

test_that("start_file_upload()/cancel_file_upload() send their triggers", {
  session <- recording_session()

  start_file_upload("test", session = session)
  cancel_file_upload("test", session = session)

  expect_equal(
    session$sent[[1]],
    list(id = "test", message = list(upload_start = TRUE))
  )
  expect_equal(
    session$sent[[2]],
    list(id = "test", message = list(upload_cancel = TRUE))
  )

  expect_error(start_file_upload(1, session = session), "id")
  expect_error(cancel_file_upload("test", 1, session = session), "\\.\\.\\.")
})

test_that("file upload readers are sugar over companion inputs", {
  session <- new.env(parent = emptyenv())
  session$input <- list(
    test__bsides_status = "uploading",
    test__bsides_progress = 0.4,
    test__bsides_staged = data.frame(name = "a.csv", size = 10, type = ""),
    test__bsides_error = error_cnd("bsides_file_failure", message = "boom")
  )

  expect_equal(file_upload_status("test", session = session), "uploading")
  expect_equal(file_upload_progress("test", session = session), 0.4)
  expect_equal(
    file_upload_staged("test", session = session),
    data.frame(name = "a.csv", size = 10, type = "")
  )
  expect_equal(
    conditionMessage(file_upload_error("test", session = session)),
    "boom"
  )

  # Before the first push each reader is total, at its idle default.
  expect_equal(file_upload_status("none", session = session), "idle")
  expect_equal(file_upload_progress("none", session = session), 0)
  expect_equal(nrow(file_upload_staged("none", session = session)), 0)
  expect_null(file_upload_error("none", session = session))
})

test_that("readers resolve inside a module", {
  module <- function(id) {
    shiny::moduleServer(id, function(input, output, session) {})
  }

  shiny::testServer(module, args = list(id = "m"), {
    session$setInputs(upl__bsides_status = "staged")

    # The module's session proxy scopes the companion name the same way
    # it scopes the input itself. (Passed explicitly: testServer's expr
    # does not run under the proxy as default domain, though a module's
    # own server code does — callModule wraps it in withReactiveDomain.)
    expect_equal(file_upload_status("upl", session = session), "staged")
  })
})

test_that("the staged input handler builds the data frame", {
  handler <- function(value) {
    shiny:::inputHandlers$get(file_staged_input_type)(value, NULL, "x")
  }

  expect_equal(nrow(handler(list())), 0)
  expect_equal(
    handler(list(
      list(name = "a.csv", size = 10L, type = "text/csv"),
      list(name = "b.bin", size = 2, type = NULL)
    )),
    data.frame(
      name = c("a.csv", "b.bin"),
      size = c(10, 2),
      type = c("text/csv", "")
    )
  )
})

# One file's `uploadEnd` result: the one-row frame Shiny sets a slot
# input to.
file_slot_frame <- function(name, datapath) {
  data.frame(
    name = name,
    size = 10,
    type = "text/csv",
    datapath = datapath
  )
}

test_that("a batch payload lands on the input as one combined frame", {
  server <- function(input, output, session) {}

  # The server's own path for a `<id>:<type>` send: dispatch to the
  # registered handler, then strip the suffix so the result lands on
  # `input$<id>`. testServer's setInputs sets raw values, so the dispatch
  # has to be driven explicitly.
  send <- function(session, payload) {
    values <- shiny:::applyInputHandlers(
      list(`upl:bsides.file.batch` = payload),
      session
    )
    do.call(session$setInputs, values)
  }

  shiny::testServer(server, {
    session$setInputs(
      upl__bsides_slot_1 = file_slot_frame("a.csv", "/tmp/0.csv"),
      upl__bsides_slot_2 = file_slot_frame("b.csv", "/tmp/1.csv")
    )

    send(session, list(seq = 1, n = 2))

    expect_equal(
      input$upl,
      data.frame(
        name = c("a.csv", "b.csv"),
        size = c(10, 10),
        type = c("text/csv", "text/csv"),
        datapath = c("/tmp/0.csv", "/tmp/1.csv")
      )
    )

    # A slot the session never received yields NULL, not an error.
    send(session, list(seq = 2, n = 9))

    expect_null(input$upl)
  })
})

test_that("the batch input handler assembles the slot inputs in order", {
  handler <- function(value, input) {
    shiny:::inputHandlers$get(file_batch_input_type)(
      value,
      list(input = input),
      "upl"
    )
  }

  input <- list(
    upl__bsides_slot_1 = file_slot_frame("a.csv", "/tmp/0.csv"),
    upl__bsides_slot_2 = file_slot_frame("b.csv", "/tmp/1.csv")
  )

  # The count decides the rows: slot position, never anything the client
  # names.
  expect_equal(
    handler(list(seq = 1, n = 2), input),
    data.frame(
      name = c("a.csv", "b.csv"),
      size = c(10, 10),
      type = c("text/csv", "text/csv"),
      datapath = c("/tmp/0.csv", "/tmp/1.csv")
    )
  )

  expect_equal(nrow(handler(list(seq = 1, n = 1), input)), 1L)

  # A slot the session never received — a restored bookmark — is not an
  # error.
  expect_null(handler(list(seq = 1, n = 3), input))
})

test_that("the batch input handler rejects a payload it cannot count", {
  handler <- function(value, input = list()) {
    shiny:::inputHandlers$get(file_batch_input_type)(
      value,
      list(input = input),
      "upl"
    )
  }

  input <- list(upl__bsides_slot_1 = file_slot_frame("a.csv", "/tmp/0.csv"))

  # Nothing here reaches `session$input`, so a hostile payload degrades to
  # NULL instead of erroring inside input dispatch.
  expect_null(handler(list(seq = 1)))
  expect_null(handler("upl__bsides_slot_1", input))
  expect_null(handler(list(seq = 1, n = 0), input))
  expect_null(handler(list(seq = 1, n = -1), input))
  expect_null(handler(list(seq = 1, n = 1.5), input))
  expect_null(handler(list(seq = 1, n = "1"), input))
  expect_null(handler(list(seq = 1, n = c(1, 2)), input))
  expect_null(handler(list(seq = 1, n = NA_real_), input))
  expect_null(handler(list(seq = 1, n = list(1)), input))

  # An arbitrary session input cannot be named into the value.
  expect_null(
    handler(list(seq = 1, n = 1, slots = list("secret")), list(secret = 1))
  )
})

test_that("the batch input handler renames datapaths by batch position", {
  handler <- function(value, input) {
    shiny:::inputHandlers$get(file_batch_input_type)(
      value,
      list(input = input),
      "upl"
    )
  }

  # One private directory per file, each holding `0.<ext>`, is what one
  # upload job per file leaves behind.
  root <- withr::local_tempdir()
  paths <- vapply(
    c("jobA", "jobB", "jobC"),
    \(job) {
      dir.create(file.path(root, job))
      path <- file.path(root, job, "0.csv")
      writeLines(job, path)
      path
    },
    character(1),
    USE.NAMES = FALSE
  )

  input <- list(
    upl__bsides_slot_1 = file_slot_frame("a.csv", paths[[1]]),
    upl__bsides_slot_2 = file_slot_frame("b.csv", paths[[2]]),
    upl__bsides_slot_3 = file_slot_frame("c.csv", paths[[3]])
  )

  frame <- handler(list(seq = 1, n = 3), input)

  expect_equal(basename(frame$datapath), c("0.csv", "1.csv", "2.csv"))
  expect_true(all(file.exists(frame$datapath)))
  expect_equal(
    vapply(frame$datapath, \(p) readLines(p), character(1), USE.NAMES = FALSE),
    c("jobA", "jobB", "jobC")
  )

  # Each file keeps its own directory, so renaming cannot move one file
  # onto another.
  expect_equal(dirname(frame$datapath), dirname(paths))

  # A datapath that is already gone is left alone rather than dropped.
  unlink(frame$datapath[[3]])
  again <- handler(
    list(seq = 2, n = 3),
    utils::modifyList(
      input,
      list(upl__bsides_slot_3 = file_slot_frame("c.csv", frame$datapath[[3]]))
    )
  )

  expect_equal(again$datapath[[3]], frame$datapath[[3]])
})

test_that("the error input handler builds the condition", {
  handler <- function(value) {
    shiny:::inputHandlers$get(file_error_input_type)(value, NULL, "x")
  }

  expect_null(handler(NULL))

  rejection <- handler(list(
    kind = "rejection",
    messages = list(
      "a.csv is larger than the 5 MB upload limit.",
      "b.txt is not an accepted file type."
    ),
    files = list(
      list(name = "a.csv", reason = "size", limit = 5242880),
      list(name = "b.txt", reason = "accept", limit = NULL)
    )
  ))

  expect_s3_class(
    rejection,
    c("bsides_file_rejection", "bsides_file_error", "error", "condition")
  )
  expect_equal(
    conditionMessage(rejection),
    paste(
      "a.csv is larger than the 5 MB upload limit.",
      "b.txt is not an accepted file type.",
      sep = "\n"
    )
  )
  expect_equal(
    rejection$files,
    data.frame(
      name = c("a.csv", "b.txt"),
      reason = c("size", "accept"),
      limit = c(5242880, NA)
    )
  )
  expect_null(conditionCall(rejection))

  failure <- handler(list(
    kind = "failure",
    messages = list("Maximum upload size exceeded"),
    files = list()
  ))

  expect_s3_class(
    failure,
    c("bsides_file_failure", "bsides_file_error", "error", "condition")
  )
  expect_equal(conditionMessage(failure), "Maximum upload size exceeded")
  expect_equal(nrow(failure$files), 0)
})

test_that("update_file() sends only the arguments it is given", {
  session <- recording_session()

  update_file(
    "test",
    accept = c(".csv", ".tsv"),
    placeholder = "Drop a file",
    disable = TRUE,
    session = session
  )

  expect_equal(
    session$sent[[1]],
    list(
      id = "test",
      message = list(
        accept = ".csv,.tsv",
        placeholder = "Drop a file",
        disable = TRUE
      )
    )
  )

  update_file("test", summary = "{files}", session = session)

  expect_equal(session$sent[[2]]$message, list(summary = "{files}"))

  expect_error(
    update_file("test", reset = TRUE, session = session),
    "\\.\\.\\."
  )
})

test_that("reset_file() sends the reset trigger", {
  session <- recording_session()

  reset_file("test", session = session)

  expect_equal(
    session$sent[[1]],
    list(id = "test", message = list(reset = TRUE))
  )
})

test_that("update_file() validates its arguments", {
  session <- recording_session()

  expect_error(update_file("test", reset = "yes", session = session), "reset")
  expect_error(
    update_file("test", placeholder = 1, session = session),
    "placeholder"
  )
  expect_error(update_file("test", "reset", session = session), "empty")
})

test_that("`summary` renders as an attribute only when given", {
  expect_match(
    format(input_file("test", summary = "{done}/{n} uploaded")),
    'summary="{done}/{n} uploaded"',
    fixed = TRUE
  )

  expect_no_match(format(input_file("test")), "summary=")

  expect_error(input_file("test", summary = 1), "summary")
})

test_that("`height` sets the dropzone custom property inline", {
  html <- format(input_file("test", height = "12rem"))

  expect_match(html, "--bsides-file-dropzone-height:12rem;", fixed = TRUE)

  # NULL adds no style attribute at all, so a theme token applies cleanly
  expect_no_match(format(input_file("test")), "style=")

  # merged with, not clobbering, an author's style passed through ...
  html <- format(input_file("test", style = "color: red", height = "12rem"))

  expect_match(
    html,
    'style="color: red; --bsides-file-dropzone-height:12rem;"',
    fixed = TRUE
  )
})

test_that("`height` is shape-checked", {
  expect_error(input_file("test", height = ""), "height")
  expect_error(input_file("test", height = "  "), "height")
  expect_error(input_file("test", height = "height: 12rem;"), "declaration")
  expect_error(input_file("test", height = 12), "height")

  # any CSS length passes -- no unit allow-list
  expect_silent(input_file("test", height = "clamp(6rem, 20vh, 16rem)"))
  expect_silent(input_file("test", height = "100dvh"))
})

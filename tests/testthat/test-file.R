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

test_that("file_upload_start()/file_upload_cancel() send their triggers", {
  session <- recording_session()

  file_upload_start("test", session = session)
  file_upload_cancel("test", session = session)

  expect_equal(
    session$sent[[1]],
    list(id = "test", message = list(upload_start = TRUE))
  )
  expect_equal(
    session$sent[[2]],
    list(id = "test", message = list(upload_cancel = TRUE))
  )

  expect_error(file_upload_start(1, session = session), "id")
  expect_error(file_upload_cancel("test", 1, session = session), "\\.\\.\\.")
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

  expect_error(update_file("test", reset = TRUE, session = session), "\\.\\.\\.")
})

test_that("reset_file() sends the reset trigger", {
  session <- recording_session()

  reset_file("test", session = session)

  expect_equal(session$sent[[1]], list(id = "test", message = list(reset = TRUE)))
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

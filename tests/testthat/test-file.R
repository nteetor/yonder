test_that("argument `id`", {
  expect_error(input_file(), "`id`")

  expect_silent(input_file("test"))
})

test_that("`select` chooses the multiple attribute", {
  expect_no_match(format(input_file("test")), "multiple")
  expect_match(format(input_file("test", select = "many")), "multiple")

  expect_error(input_file("test", select = "all"), "select")
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

test_that("update_file() sends only the arguments it is given", {
  session <- recording_session()

  update_file("test", reset = TRUE, session = session)

  expect_equal(session$sent[[1]], list(id = "test", message = list(reset = TRUE)))

  update_file(
    "test",
    accept = c(".csv", ".tsv"),
    placeholder = "Drop a file",
    disable = TRUE,
    session = session
  )

  expect_equal(
    session$sent[[2]]$message,
    list(accept = ".csv,.tsv", placeholder = "Drop a file", disable = TRUE)
  )

  update_file("test", summary = "{files}", session = session)

  expect_equal(session$sent[[3]]$message, list(summary = "{files}"))
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

# `MockShinySession$sendInputMessage()` is a warning no-op, so updates are
# checked against a session that simply records what it was sent.
recording_session <- function() {
  session <- new.env(parent = emptyenv())
  session$sent <- list()

  session$sendInputMessage <- function(id, message) {
    session$sent[[length(session$sent) + 1]] <- list(
      id = id,
      message = message
    )
    invisible()
  }

  session
}

test_that("argument `id`", {
  expect_error(input_numeric(), "`id`")

  expect_error(input_numeric(20), "`id`")

  expect_silent(input_numeric("test"))
})

test_that("numeric arguments are validated", {
  expect_error(input_numeric("x", value = "1"), "`value`")

  expect_error(input_numeric("x", min = "1"), "`min`")

  expect_error(input_numeric("x", max = "1"), "`max`")

  expect_error(input_numeric("x", step = "1"), "`step`")
})

test_that("the input carries the binding's class", {
  html <- format(input_numeric(id = "x"))

  expect_match(html, "bsides-input-numeric", fixed = TRUE)
  expect_match(html, "form-control", fixed = TRUE)
  expect_match(html, 'type="number"', fixed = TRUE)
})

test_that("value, min, max, and step render as attributes", {
  html <- format(
    input_numeric(id = "x", value = 5, min = 0, max = 10, step = 2)
  )

  expect_match(html, 'value="5"', fixed = TRUE)
  expect_match(html, 'min="0"', fixed = TRUE)
  expect_match(html, 'max="10"', fixed = TRUE)
  expect_match(html, 'step="2"', fixed = TRUE)
})

test_that("`...` becomes attributes on the input", {
  html <- format(input_numeric(id = "x", `data-test` = "yes"))

  expect_match(html, 'data-test="yes"', fixed = TRUE)
})

test_that("numbers render without scientific notation", {
  html <- format(input_numeric(id = "x", value = 1e6, min = 1e-6))

  expect_match(html, 'value="1000000"', fixed = TRUE)
  expect_match(html, 'min="0.000001"', fixed = TRUE)
  expect_no_match(html, "e+", fixed = TRUE)
  expect_no_match(html, "e-", fixed = TRUE)
})

test_that("scientific notation is avoided regardless of `scipen`", {
  withr::local_options(scipen = -9)

  html <- format(input_numeric(id = "x", value = 1e6))

  expect_match(html, 'value="1000000"', fixed = TRUE)
})

test_that("a standard label wraps the input", {
  html <- format(input_numeric(id = "x", label = "Count"))

  expect_match(html, '<label class="form-label" for="x">', fixed = TRUE)
  expect_match(html, "Count", fixed = TRUE)
})

test_that("a floating label wraps the input", {
  html <- format(input_numeric(id = "x", label = floating_label("Count")))

  expect_match(html, "form-floating", fixed = TRUE)
  expect_match(html, '<label for="x">', fixed = TRUE)
})

test_that("`update_numeric()` argument `id`", {
  session <- recording_session()

  expect_error(update_numeric(session = session), "`id`")

  expect_error(update_numeric(20, session = session), "`id`")
})

test_that("`update_numeric()` validates its arguments", {
  session <- recording_session()

  expect_error(update_numeric("x", value = "1", session = session), "`value`")

  expect_error(update_numeric("x", min = "1", session = session), "`min`")

  expect_error(update_numeric("x", max = "1", session = session), "`max`")

  expect_error(update_numeric("x", step = "1", session = session), "`step`")

  # `disable` is a boolean, not a number
  expect_error(update_numeric("x", disable = 1, session = session), "`disable`")

  expect_silent(update_numeric("x", disable = TRUE, session = session))
})

test_that("`update_numeric()` rejects positional arguments", {
  session <- recording_session()

  # without `check_dots_empty()` this is a silent no-op
  expect_error(update_numeric("x", 42, session = session), "empty")
})

test_that("`update_numeric()` drops NULLs", {
  session <- recording_session()

  update_numeric("x", value = 5, session = session)

  expect_length(session$sent, 1)
  expect_equal(session$sent[[1]]$id, "x")
  expect_equal(session$sent[[1]]$message, list(value = "5"))
})

test_that("`update_numeric()` formats numbers without scientific notation", {
  session <- recording_session()

  update_numeric("x", value = 1e6, session = session)

  expect_equal(session$sent[[1]]$message, list(value = "1000000"))
})

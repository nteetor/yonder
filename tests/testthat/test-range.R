test_that("argument `id`", {
  expect_error(input_range(), "`id`")

  expect_error(input_range(20), "`id`")

  expect_silent(input_range("test"))
})

test_that("numeric arguments are validated", {
  expect_error(input_range("x", min = "1"), "`min`")

  expect_error(input_range("x", max = "1"), "`max`")

  expect_error(input_range("x", value = "1"), "`value`")

  expect_error(input_range("x", step = "1"), "`step`")
})

test_that("`value` must sit between `min` and `max`", {
  expect_error(input_range("x", min = 0, max = 100, value = 200), "`value`")

  expect_error(input_range("x", min = 0, max = 100, value = -1), "`value`")

  expect_silent(input_range("x", min = 0, max = 100, value = 50))
})

test_that("the input carries the binding's class", {
  html <- format(input_range(id = "x"))

  expect_match(html, "bsides-input-range", fixed = TRUE)
  expect_match(html, "form-range", fixed = TRUE)
  expect_match(html, 'type="range"', fixed = TRUE)
})

test_that("value, min, max, and step render as attributes", {
  html <- format(
    input_range(id = "x", min = 0, max = 10, value = 5, step = 2)
  )

  expect_match(html, 'min="0"', fixed = TRUE)
  expect_match(html, 'max="10"', fixed = TRUE)
  expect_match(html, 'value="5"', fixed = TRUE)
  expect_match(html, 'step="2"', fixed = TRUE)
})

test_that("`value` defaults to `min`", {
  html <- format(input_range(id = "x", min = 20, max = 40))

  expect_match(html, 'value="20"', fixed = TRUE)
})

test_that("`...` becomes attributes on the input", {
  html <- format(input_range(id = "x", `data-test` = "yes"))

  expect_match(html, 'data-test="yes"', fixed = TRUE)
})

test_that("an unlabelled input leaves the control without an id", {
  html <- format(input_range(id = "x"))

  # only the outer element is addressable, the control needs no id
  expect_match(html, '<div class="bsides-input-range" id="x">', fixed = TRUE)
  expect_no_match(html, '<input class="form-range" id=', fixed = TRUE)
})

test_that("a label points at the control, not the outer element", {
  html <- format(input_range(id = "x", label = "Volume"))

  expect_match(html, "Volume", fixed = TRUE)
  expect_match(html, '<label class="form-label" for="range-', fixed = TRUE)

  # the generated id lands on the control the label names
  control_id <- sub('.*<label class="form-label" for="([^"]+)".*', "\\1", html)

  expect_match(html, sprintf('<input class="form-range" id="%s"', control_id))
})

test_that("a floating label is rejected", {
  # ranges are not `.form-control` inputs, floating labels do not apply
  expect_error(
    input_range(id = "x", label = floating_label("Volume")),
    "floating"
  )
})

test_that("`update_range()` argument `id`", {
  session <- recording_session()

  expect_error(update_range(session = session), "`id`")

  expect_error(update_range(20, session = session), "`id`")

  expect_error(update_range("", session = session), "`id`")
})

test_that("`update_range()` validates its arguments", {
  session <- recording_session()

  expect_error(update_range("x", value = "1", session = session), "`value`")

  # `disable` is a boolean, not a number
  expect_error(update_range("x", disable = 1, session = session), "`disable`")

  expect_error(update_range("x", disable = "TRUE", session = session), "`disable`")

  expect_silent(update_range("x", disable = TRUE, session = session))

  expect_silent(update_range("x", disable = FALSE, session = session))
})

test_that("`update_range()` sends `disable` as a boolean", {
  session <- recording_session()

  update_range("x", disable = TRUE, session = session)

  # the binding assigns this straight to `range.disabled`
  expect_equal(session$sent[[1]]$message, list(disable = TRUE))

  update_range("x", disable = FALSE, session = session)

  expect_equal(session$sent[[2]]$message, list(disable = FALSE))
})

test_that("`update_range()` drops NULLs", {
  session <- recording_session()

  update_range("x", value = 5, session = session)

  expect_length(session$sent, 1)
  expect_equal(session$sent[[1]]$id, "x")
  expect_equal(session$sent[[1]]$message, list(value = 5))
})

test_that("`update_range()` sends value and disable together", {
  session <- recording_session()

  update_range("x", value = 5, disable = TRUE, session = session)

  expect_equal(session$sent[[1]]$message, list(value = 5, disable = TRUE))
})

test_that("`update_range()` with nothing to send still messages the input", {
  session <- recording_session()

  update_range("x", session = session)

  expect_length(session$sent, 1)
  expect_length(session$sent[[1]]$message, 0)
})

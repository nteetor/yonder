test_that("argument `id`", {
  expect_error(collapse_panel(), "`id` must be a single string")

  expect_error(collapse_panel(20), "`id` must be a single string")

  expect_error(collapse_panel(NULL), "`id` must be a single string")

  expect_silent(collapse_panel("x"))
})

test_that("arguments `state` and `direction` are matched", {
  expect_error(collapse_panel("x", state = "ajar"))

  expect_error(collapse_panel("x", direction = "diagonal"))
})

test_that("the panel carries the binding's class", {
  html <- format(collapse_panel(id = "x"))

  # `bsides-collapse` is the binding's selector, `collapse` is Bootstrap's.
  expect_match(html, 'class="bsides-collapse collapse"', fixed = TRUE)
  expect_match(html, 'id="x"', fixed = TRUE)
})

test_that("`state` controls the show class", {
  closed <- format(collapse_panel(id = "x"))
  open <- format(collapse_panel(id = "x", state = "open"))

  expect_no_match(closed, "show", fixed = TRUE)
  expect_match(open, "show", fixed = TRUE)
})

test_that("`direction` controls the horizontal class", {
  vertical <- format(collapse_panel(id = "x"))
  horizontal <- format(collapse_panel(id = "x", direction = "horizontal"))

  expect_no_match(vertical, "collapse-horizontal", fixed = TRUE)
  expect_match(horizontal, "collapse-horizontal", fixed = TRUE)
})

test_that("`...` becomes the panel's content", {
  html <- format(collapse_panel(id = "x", "Panel body"))

  expect_match(html, "Panel body", fixed = TRUE)
})

test_that("`collapse_panel_button()` argument `target`", {
  expect_error(collapse_panel_button(), "`target` must be a single string")

  expect_error(
    collapse_panel_button(20, "Go"),
    "`target` must be a single string"
  )

  expect_error(
    collapse_panel_button(NULL, "Go"),
    "`target` must be a single string"
  )
})

test_that("the button carries the attributes Bootstrap's data-api reads", {
  html <- format(collapse_panel_button("x", "Toggle"))

  expect_match(html, 'data-bs-toggle="collapse"', fixed = TRUE)
  expect_match(html, 'data-bs-target="#x"', fixed = TRUE)
  expect_match(html, 'aria-controls="x"', fixed = TRUE)
  expect_match(html, "Toggle", fixed = TRUE)
})

test_that("`open_collapse_panel()` argument `id`", {
  session <- recording_session()

  expect_error(open_collapse_panel(session = session), "`id`")

  expect_error(open_collapse_panel(20, session = session), "`id`")
})

test_that("`close_collapse_panel()` argument `id`", {
  session <- recording_session()

  expect_error(close_collapse_panel(session = session), "`id`")

  expect_error(close_collapse_panel(20, session = session), "`id`")
})

test_that("`toggle_collapse_panel()` argument `id`", {
  session <- recording_session()

  expect_error(toggle_collapse_panel(session = session), "`id`")

  expect_error(toggle_collapse_panel(20, session = session), "`id`")
})

# The client dispatches on `method`, so these strings are a cross-system
# contract with `receiveMessage()` in srcts/src/components/collapse.ts.
test_that("`open_collapse_panel()` sends method open", {
  session <- recording_session()

  open_collapse_panel("x", session = session)

  expect_length(session$sent, 1)
  expect_equal(session$sent[[1]]$id, "x")
  expect_equal(session$sent[[1]]$message, list(method = "open"))
})

test_that("`close_collapse_panel()` sends method close", {
  session <- recording_session()

  close_collapse_panel("x", session = session)

  expect_length(session$sent, 1)
  expect_equal(session$sent[[1]]$id, "x")
  expect_equal(session$sent[[1]]$message, list(method = "close"))
})

test_that("`toggle_collapse_panel()` sends method toggle", {
  session <- recording_session()

  toggle_collapse_panel("x", session = session)

  expect_length(session$sent, 1)
  expect_equal(session$sent[[1]]$id, "x")
  expect_equal(session$sent[[1]]$message, list(method = "toggle"))
})

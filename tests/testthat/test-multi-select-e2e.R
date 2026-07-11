# End-to-end tests for input_multi_select() / <bsides-multi-select>:
# real browser, real Shiny session.

launch_multi_select_app <- function() {
  shinytest2::AppDriver$new(
    test_path("apps", "multi-select"),
    name = "multi-select",
    variant = NULL,
    load_timeout = 30 * 1000
  )
}

test_that("multi-select adds chips on Enter and drops them on close", {
  skip_if_no_e2e()

  app <- launch_multi_select_app()
  withr::defer(app$stop())

  dispatch_key(app, "#ms .multi-select-input", "Enter", value = "Tag1")
  expect_equal(app$get_value(input = "ms"), "Tag1")

  # duplicates are rejected and the typed text stays visible
  dispatch_key(app, "#ms .multi-select-input", "Enter", value = "Tag1")
  expect_equal(app$get_value(input = "ms"), "Tag1")
  expect_equal(
    app$get_js("document.querySelector('#ms .multi-select-input').value"),
    "Tag1"
  )

  # a second, distinct chip
  dispatch_key(app, "#ms .multi-select-input", "Enter", value = "Tag2")
  expect_setequal(app$get_value(input = "ms"), c("Tag1", "Tag2"))

  # Backspace in an empty input removes the last chip
  dispatch_key(app, "#ms .multi-select-input", "Backspace", value = "")
  expect_equal(app$get_value(input = "ms"), "Tag1")

  # the close button removes a chip; the reported value is post-removal
  app$click(selector = "#ms bsides-chip .btn-close")
  app$wait_for_idle()
  expect_length(app$get_value(input = "ms"), 0)
})

test_that("multi-select seeds initial chips and enforces max", {
  skip_if_no_e2e()

  app <- launch_multi_select_app()
  withr::defer(app$stop())

  # initial value from input_multi_select(select = )
  expect_setequal(app$get_value(input = "msmax"), c("A", "B"))

  # reaching max disables the text input
  dispatch_key(app, "#msmax .multi-select-input", "Enter", value = "C")
  expect_setequal(app$get_value(input = "msmax"), c("A", "B", "C"))
  expect_true(
    app$get_js("document.querySelector('#msmax .multi-select-input').disabled")
  )

  # over-max entry is impossible; removing a chip re-enables the input
  app$click(selector = "#msmax bsides-chip:first-of-type .btn-close")
  app$wait_for_idle()
  expect_length(app$get_value(input = "msmax"), 2)
  expect_false(
    app$get_js("document.querySelector('#msmax .multi-select-input').disabled")
  )
})
